Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0FGLY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:24:56 -0400
Received: from daytona.panasas.com ([67.152.220.89]:19682 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756579Ab0FGLYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:24:53 -0400
Message-ID: <4C0CD700.10906@panasas.com>
Date: Mon, 07 Jun 2010 14:24:48 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>,
       Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 3/3] [tgt]: Add BSG v4 backstore support to usr/bs_sg.c
References: <1275882640-5418-1-git-send-email-nab@linux-iscsi.org>	 <4C0CB071.8040805@panasas.com>	 <1275901324.26888.56.camel@haakon2.linux-iscsi.org>	 <4C0CBB89.9000209@panasas.com>	 <1275903449.26888.69.camel@haakon2.linux-iscsi.org>	 <4C0CCB69.6020506@panasas.com> <1275908828.26888.90.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1275908828.26888.90.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2010 11:24:51.0713 (UTC) FILETIME=[0BDA8F10:01CB0634]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 02:07 PM, Nicholas A. Bellinger wrote:
> On Mon, 2010-06-07 at 13:35 +0300, Boaz Harrosh wrote:
>> On 06/07/2010 12:37 PM, Nicholas A. Bellinger wrote:
>>> On Mon, 2010-06-07 at 12:27 +0300, Boaz Harrosh wrote:
>>>> On 06/07/2010 12:02 PM, Nicholas A. Bellinger wrote:
>>>>> On Mon, 2010-06-07 at 11:40 +0300, Boaz Harrosh wrote:
>>>>>> On 06/07/2010 06:50 AM, Nicholas A. Bellinger wrote:
>>>>>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>>>>>
>>>>>>> This patch adds initial support for the block layer implementation of the sg v4 interface
>>>>>>> (BSG) -> STGT with a new struct backingstore_template bsg_bst sharing code with the
>>>>>>> original sg_bst.  It adds for new function bs_bsg_cmd_submit() for incoming write I/O
>>>>>>> and bs_bsg_cmd_complete() for polling read I/O using include/linux/bsg.h:struct sg_io_v4.
>>>>>>>
>>>>>>> This patch also splits up bs_sg_open() to support both BSG and SG looking for the
>>>>>>> path "/dev/bsg" in bs_sg_open(), and getting max_queue using SG_GET_COMMAND_Q and
>>>>>>> calling SG_SET_RESERVED_SIZE (following the original bs_sg code in init_sg_device)
>>>>>>>
>>>>>>> Also chk_bsg_device() currently using a hardcoded 254 major as def for BSG does not
>>>>>>> appear in include/linux/major.h just yet..
>>>>>>>
>>>>>>> So far this has been tested with STGT/iSCSI <-> BSG <-> TCM_Loop SPC-4 iSCSI Target
>>>>>>> Port emulation and is able to mkfs, fsck and mount a filesystem from a TCM/IBLOCK
>>>>>>> Linux LVM kernel level backstore
>>>>>>>
>>>>>>> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
>>>>>>> ---
>>>>>>>  usr/bs_sg.c     |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>>>>>>>  usr/scsi_cmnd.h |    7 ++
>>>>>>>  2 files changed, 175 insertions(+), 10 deletions(-)
>>>>>>>
>>>>>>> diff --git a/usr/bs_sg.c b/usr/bs_sg.c
>>>>>>> index 23676ef..d071714 100644
>>>>>>> --- a/usr/bs_sg.c
>>>>>>> +++ b/usr/bs_sg.c
>>>>>
>>>>> <SNIP>
>>>>>
>>>>>>> +
>>>>>>> +static int bs_bsg_cmd_submit(struct scsi_cmd *cmd)
>>>>>>> +{
>>>>>>> +	struct scsi_lu *dev = cmd->dev;
>>>>>>> +	int fd = dev->fd;
>>>>>>> +	struct sg_io_v4 *io_hdr = &cmd->cmd_bsg_hdr;
>>>>>>> +	int err = 0;
>>>>>>> +	/*
>>>>>>> +	 * Following linux/include/linux/bsg.h
>>>>>>> +	 */
>>>>>>> +	/* [i] 'Q' to differentiate from v3 */
>>>>>>> +	io_hdr->guard = 'Q';
>>>>>>> +	io_hdr->protocol = BSG_PROTOCOL_SCSI;
>>>>>>> +	io_hdr->subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD;
>>>>>>> +	io_hdr->request_len = cmd->scb_len;
>>>>>>> +	io_hdr->request = (unsigned long )cmd->scb;
>>>>>>> +
>>>>>>> +	if (scsi_get_data_dir(cmd) == DATA_WRITE) {
>>>>>>
>>>>>> Why the if? both sides are fully bidi just remove the ifs
>>>>>> and: OUT <= OUT, IN <= IN
>>>>>>
>>>>>
>>>>> Whoops, thanks for pointing this one out (again).  Tested with
>>>>> unidirection commands and included into my local tgt.git/pass that I
>>>>> will send along to Tomo-san..
>>>>>
>>>>> Btw, I still need to sort out BIDI support for TCM_Loop at some point in
>>>>> the not too distant future.  What would be a good way to generate BIDI
>>>>> traffic into STGT or a local SCSI LLD..?
>>>>
>>>> scsi_debug has some emulation for XOR commands, does that help?
>>>>
>>>
>>> Great, thanks for the pointer on the LLD side.  Is there any userspace
>>> code around that will generate XDWRITEREAD_* CDBs for bulk I/O or do I
>>> need to code this part myself..?
>>>
>>> Best,
>>>
>>> --nab
>>>
>>
>> You could use iscsi as LLD and generate OSD heavy traffic. (With a real osd_tgtd
>> on the end side). But that will need more work, right?
> 
> Hmmm, suppose I need to read up a bit on how to generate osd_tgtd
> traffic..
> 

Generating is easy, there is the exofs filke system that given an osd
will export a VFS filesystem over it. but...

>>  what does the TCM_Loop
>> do exactly. Please forgive my laziness, I never took the time to find out.
>>
> 
> TCM_Loop is a TCM fabric module that appears under /sys/kernel/config/target/loopback/
> that emulates SAS, FC and iSCSI WWPN Ports and their assocated I_T Nexus
> for SPC-4 PR and ALUA operations.  TCM_Loop registers as a Linux/SCSI
> LLD (a la scsi_debug) that presents TCM backstores (IBLOCK, FILEIO,
> RAMDISK) as a local struct scsi_device with a complete set of WWN port
> naming identifiers (sg_inq -i) and TransportIDs (for PR).
> 
> With TCM v4 code in lio-core-2.6.git/lio-4.0, TCM_Loop has been
> converted along with the rest of the v4.x fabric modules to use a
> generic set of struct config_group logic from
> drivers/target/target_core_fabric_configfs.c.  There is a bit of
> information on the wiki at:
> 
> http://linux-iscsi.org/index.php/TCM_loop
> 
> but as you will notice the screenshots are still referencing the
> original tests from last year with VMware Workstation.  Things have
> changed quite a bit since then as TCM_Loop has gone from using internal
> SAS WWPN+Nexus emulation to providing multi-protocol support based on
> configfs provided WWPNs using the new generic naming handers from
> drivers/target/target_core_fabric_lib.c
> 

OK, so from what I understand, from a SCSI stack perspective it is the lowest
end target, using the local machine's backing store.

That will not help at all with OSD. With osd_tgtd (In user mode) we use the iscsi
protocol driver, but define a new disk-type, "osd" and a new backing-store "osdemu"
which does a complete OSD-CDB decoding and implementation. Current code is not good
for you because it's heavily user-mode dependent including an sqlite3 DB for storing
attributes.

Cheers
Boaz

> Best,
> 
> --nab
> 
