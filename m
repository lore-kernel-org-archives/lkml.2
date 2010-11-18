Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab0KRUmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:42:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760353Ab0KRUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:42:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 12:41:22 -0800
Message-ID: <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Anderson <andmike@us.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:30 AM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> This is the fourth time I send this patch. For some reason it seems unable
> to get any feedback at all. I'd really appreciate a clear ACK or NACK on
> it and I'll keep resending it until it's either merged or I get a NACK
> with a reason.

The patch looks ok to me, but you've basically selected the least
interesting file possible. No wonder people can't seem to care.

Also, this is just ugly as hell, and doesn't help anything:

+       int (*eh_abort_handler)(struct scsi_cmnd *) =
+               scmd->device->host->hostt->eh_abort_handler;

since the compiler will have optimized that double access away anyway
(no writes in between). So you could have made it about a thousand
times more readable with no downside by doing

    struct scsi_host_template *hostt = scmd->device->host->hostt;

    if (!hostt->eh_abort_handler)
        return FAILED;
    return hostt->eh_abort_handler(scmd);

instead. Look ma, no long lines.

Rule of thumb: if you need more than one line for an expression or
variable definition, you're doing something wrong.

                Linus
