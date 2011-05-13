Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab1EMTar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 15:30:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50671 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1EMTan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 15:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CGrOIm25uRgdphsmooVODrNKSFUaxe9hzrr3FOwmMSlrTAYorB/3SGg7APXHQphEmO
         wHHWYyqaase8ARnY5PUPrQcd8mQ3+0nmW5gG9q4zETu254v28kw5PthtImlu8rokxQgF
         tQJ5PMTI/xaIkI6cpv5/pKtqxz0SvllQidExk=
MIME-Version: 1.0
In-Reply-To: <1305184041-32189-14-git-send-email-nab@linux-iscsi.org>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
	<1305184041-32189-14-git-send-email-nab@linux-iscsi.org>
Date: Fri, 13 May 2011 21:30:41 +0200
Message-ID: <BANLkTikMdAUjT=G+DHaJwDOXuh532uN8nw@mail.gmail.com>
Subject: Re: [PATCH-v3 13/14] iscsi-target: Add misc utility and debug logic
From: Arne Redlich <arne.redlich@googlemail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/12 Nicholas A. Bellinger <nab@linux-iscsi.org>:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This file adds iscsi_target_util.[c,h] code containing a number
> of miscellaneous utility functions for iscsi_target_mod.
>
> It also contains iscsi_debug.h macros for CONFIG_ISCSI_TARGET_DEBUG
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

<snip>

> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> new file mode 100644
> index 0000000..af1c5c44
> --- /dev/null
> +++ b/drivers/target/iscsi/iscsi_target_util.c

<snip>

> +
> +struct iscsi_r2t *iscsit_get_r2t_for_eos(
> +       struct iscsi_cmd *cmd,
> +       u32 offset,
> +       u32 length)
> +{
> +       struct iscsi_r2t *r2t;
> +
> +       spin_lock_bh(&cmd->r2t_lock);
> +       list_for_each_entry(r2t, &cmd->cmd_r2t_list, r2t_list) {
> +               if ((r2t->offset <= offset) &&
> +                   (r2t->offset + r2t->xfer_len) >= (offset + length))
> +                       break;
> +       }
> +       spin_unlock_bh(&cmd->r2t_lock);
> +
> +       if (!r2t) {
> +               printk(KERN_ERR "Unable to locate R2T for Offset: %u, Length:"
> +                               " %u\n", offset, length);
> +               return NULL;
> +       }
> +
> +       return r2t;
> +}
> +

Nicholas,

This lookup pattern (repeated several times throughout the patch)
looks seriously flawed to me as r2t will never be NULL.

Arne
