Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1LVSiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:38:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54268 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1LVSiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:38:18 -0500
MIME-Version: 1.0
In-Reply-To: <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com> <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 10:37:56 -0800
X-Google-Sender-Auth: 3IIw1RZvQYdnlDlqrEm9tPssxAg
Message-ID: <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:02 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Linux allows executing the SG_IO ioctl on a partition or even on an
> LVM volume, and will pass the command to the underlying block device.
> This is well-known, but it is also a large security problem when (via
> Unix permissions, ACLs, SELinux or a combination thereof) a program or
> user needs to be granted access to a particular partition or logical
> volume but not to the full device.

So who actually *does* this in practice?

> +       /* In particular, rule out all resets and host-specific ioctls.  */
> +       return -ENOTTY;

This kind of crazy needs to go away.

If it's a permission problem, state that. Don't turn it into ENOTTY that then:

> +               return ret == -ENOTTY ? -ENOIOCTLCMD : ret;

gets turned into another random error number.

That's just crazy. No way am I ever applying patches *this* confused
without some serious explanation. And quite frankly, probably not even
then.

If it's a permission issue, return EPERM. Nothing else.

If returning EPERM causes problems for eject or other user tools,
explain it. And then just say "ok, we allow eject on a partition, and
it ejects the disk".

                       Linus
