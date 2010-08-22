Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0HVTGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 15:06:31 -0400
Received: from daytona.panasas.com ([67.152.220.89]:23599 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750996Ab0HVTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 15:06:29 -0400
Message-ID: <4C71752E.50203@panasas.com>
Date: Sun, 22 Aug 2010 22:06:22 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-iscsi-target-dev@googlegroups.com
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Aug 2010 19:06:26.0450 (UTC) FILETIME=[1E990F20:01CB422D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 01:45 AM, Nicholas A. Bellinger wrote:
> Greetings mnc and tomo,
> 
> So as per our discussions last week, I will be moving forward with the
> conversion of the LIO-Target iSCSI fabric module v4 to use protocol and
> PDU include/scsi/iscsi_proto.h.  As mnc and I agreed privately, this is
> going to the right level of integration for v2.6.37, as making libiscsi
> target mode aware does not really make for a target mode iSCSI stack
> sense due to the amount of logic in place for kernel <-> user with the
> Open-iSCSI initiator.
> 
> So aside from the main tedious work that will be involved in actually
> producing a patch for this on my end, I did notice one immediate item
> that will cause an extra headache..  This involves the struct
> iscsi_init_* and struct iscsi_target* structure definitions in:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/lio-target/iscsi_protocol.h;hb=refs/heads/lio-4.0
> 
> namely that they all have trailing 'u32 header_digest' member that a
> decent amount of utility code in iscsi_target.c and iscsi_target_util.c
> currently depends upon.
> 
> So, assuming that the conversion of all struct iscsi_init_* and struct
> iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
> checking structure size and renaming the member use in
> drivers/target/lio-target, would it be acceptable to do something like:
> 
> /* iSCSI PDU Header */
> struct iscsi_cmd {
>         uint8_t opcode;
>         uint8_t flags;
>         __be16 rsvd2;
>         uint8_t hlength;
>         uint8_t dlength[3];
>         uint8_t lun[8];
>         itt_t    itt;   /* Initiator Task Tag */
>         __be32 data_length;
>         __be32 cmdsn;
>         __be32 exp_statsn;
>         uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
>         /* Additional Data (Command Dependent) */
> #ifdef ISCSI_TARGET_MODE
>         __be32 header_digest;
> #endif
> };
> 

No, Nic that will not work. struct iscsi_cmd is just part of a full header
that can have additional AHSs before the final header_digest that
signs them all. Here above is just the common first part.
(We will need these AHSs support sooner then later in LIO as well ;-))

There are other structs that do include the above + header_digest
as an aggregate that you can use.

two things:
1. Still jet-lagged / summer vacation family duties. Let me get
   up to speed, I'll even send some ruff sketches for you.

2. Please get me up to speed with a ruff code map (Which files?
   where?) for the iscsi code. I can do both the bidi and the AHSs
   for you, which are very related. Actually AHSs is the harder part
   (which is simple really).
   a. Any high level documentation.
   b. The best code for review. Both git-tree to pull, and git-web
      if available.

> for the existing PDU defs in iscsi_proto.h in order to the pain
> of having to convert this over in existing LIO-Target fabric module
> code..?  This really help me alot.
> 
> Thanks!
> 

Thanks
Boaz

> --nab
> 
