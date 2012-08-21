Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2HUJma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:42:30 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57456 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab2HUJm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:42:26 -0400
Message-ID: <503357F9.2020606@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 17:42:17 +0800
From: Cong Meng <mc@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, stefanha@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, zwanp@cn.ibm.com, linuxram@us.ibm.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v1] virtio-scsi: get and set the queue limits for sg device
References: <1345537609-21676-1-git-send-email-mc@linux.vnet.ibm.com> <CAJSP0QXwFZdoDsizTozmXa2P=iRT7RQ_yQcVRC4FemiSpKG_bA@mail.gmail.com>
In-Reply-To: <CAJSP0QXwFZdoDsizTozmXa2P=iRT7RQ_yQcVRC4FemiSpKG_bA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082109-9264-0000-0000-0000022B7DE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue 21 Aug 2012 04:53:59 PM CST, Stefan Hajnoczi wrote:
> On Tue, Aug 21, 2012 at 9:26 AM, Cong Meng <mc@linux.vnet.ibm.com> wrote:
>> Each virtio scsi HBA has global request queue limits. But the passthrough
>> LUNs (scsi-generic) come from different host HBAs may have different request
>> queue limits. If the guest sends commands that exceed the host limits, the
>> commands will be rejected by host HAB.
>>
>> This patch addresses this issue by getting the per-LUN queue limits via the the
>> newly added virtio control request, then setting them properly.
>>
>> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
>> ---
>>   drivers/scsi/virtio_scsi.c  |  113 +++++++++++++++++++++++++++++++++++++------
>>   include/linux/virtio_scsi.h |   18 +++++++
>>   2 files changed, 116 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 173cb39..ec5066f 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -35,12 +35,14 @@ struct virtio_scsi_cmd {
>>                  struct virtio_scsi_cmd_req       cmd;
>>                  struct virtio_scsi_ctrl_tmf_req  tmf;
>>                  struct virtio_scsi_ctrl_an_req   an;
>> +               struct virtio_scsi_ctrl_lq_req   lq;
>>          } req;
>>          union {
>>                  struct virtio_scsi_cmd_resp      cmd;
>>                  struct virtio_scsi_ctrl_tmf_resp tmf;
>>                  struct virtio_scsi_ctrl_an_resp  an;
>>                  struct virtio_scsi_event         evt;
>> +               struct virtio_scsi_ctrl_lq_resp  lq;
>>          } resp;
>>   } ____cacheline_aligned_in_smp;
>>
>> @@ -469,6 +471,46 @@ out:
>>          return ret;
>>   }
>>
>> +static u32 virtscsi_lun_query(struct scsi_device *sdev, u32 *value, u32 subtype)
>> +{
>> +       struct Scsi_Host *shost = sdev->host;
>> +       struct virtio_scsi *vscsi = shost_priv(shost);
>> +       DECLARE_COMPLETION_ONSTACK(comp);
>> +       struct virtio_scsi_cmd *cmd;
>> +       struct virtio_scsi_target_state *tgt = vscsi->tgt[sdev->id];
>> +       unsigned int ret = VIRTIO_SCSI_S_FAILURE;
>> +
>> +       cmd = mempool_alloc(virtscsi_cmd_pool, GFP_ATOMIC);
>> +       if (!cmd)
>> +               goto out;
>> +
>> +       memset(cmd, 0, sizeof(*cmd));
>> +       cmd->comp = &comp;
>> +       cmd->req.lq = (struct virtio_scsi_ctrl_lq_req){
>> +               .type = VIRTIO_SCSI_T_LUN_QUERY,
>> +               .subtype = subtype,
>> +               .lun[0] = 1,
>> +               .lun[1] = sdev->id,
>> +               .lun[2] = (sdev->lun >> 8) | 0x40,
>> +               .lun[3] = sdev->lun & 0xff,
>
> The LUN addressing code has been duplicated several times now.  How
> about replacing it with something like

sure. I will include it.

Thnaks.
Cong.

>
> static void virtio_scsi_set_lun(u8 *lun, struct scsi_device *sdev)
> {
>      lun[0] = 1;
>      lun[1] = sdev->id;
>      lun[2] = (sdev->lun >> 8) | 0x40;
>      lun[3] = sdev->lun & 0xff;
>      lun[4] = lun[5] = lun[6] = lun[7] = 0;
> }
>

