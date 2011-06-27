Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1F0Cu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 22:50:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308Ab1F0Cuc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 22:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <20110626130607.5931a2f8@pedra>
References: <cover.1309103285.git.mchehab@redhat.com> <20110626130607.5931a2f8@pedra>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Jun 2011 19:49:42 -0700
Message-ID: <BANLkTimBxTpzK3Ooc-gz=nJbhZ1Mu5d1cQ@mail.gmail.com>
Subject: Re: [PATCH 01/14] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl
 doesn't exist
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 9:06 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> +       <term><errorcode>ENOIOCTLCMD</errorcode></term>
> +       <listitem>
> +         <para>The application attempted to use a non-existent ioctl. This is returned by the V4L2 core only.
> +               Applications should be able to handle this error code, in order to detect if a new ioctl is
> +               not implemented at the current Kernel version. Kernel versions lower than 3.0 returns EINVAL to
> +               non-existing ioctl's.</para>

This seems entirely bogus.

ENOICTLCMD is meant to be an entirely kernel-internal one, which is
meant to never be shown to user space. IOW, vfs_ioctl() turns it into
EINVAL (which I personally think is bogus - traditionally ENOTTY is
the right one for "not a valid ioctl", but there are people who
disagree - whatever)

The rationale for it is mainly as a way for layers inside the kernel
to determine the difference between "ioctl existed but failed with
EINVAL" vs "ioctl doesn't actually exist". Some layers try first one
thing and then another, and want to know the difference. An example of
that might be some code that first tries to call device-specific
version, and if that doesn't exist, do a generic emulation version.

Of course, as far as I can tell, almost nothing does that anyway.
Regardless, it's definitely wrong to document it as being returned to
user land. It should never be user-visible.

                  Linus
