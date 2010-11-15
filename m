Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0KOIzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:55:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0KOIy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:54:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Kent <raven@themaw.net>
Subject: Re: autofs4 hang in 2.6.37-rc1
Date: Mon, 15 Nov 2010 09:54:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, autofs@linux.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4CDFDC2B.6040205@redhat.com> <4CE00194.3070601@redhat.com> <1289785533.3248.18.camel@localhost>
In-Reply-To: <1289785533.3248.18.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011150954.34289.arnd@arndb.de>
X-Provags-ID: V02:K0:DcSa6JhDdNDtHkNHqxt9UOm0EIoTzKQ318n81drANrA
 6uVIUWIkzPNjnlR2qEJPaQtX/MHZ2JXVJ2FpZZE3VEhwgmFghm
 n4z4t8FH9hFY+0cf6dDZiFqnCJdLEOkDjxqQ/6LD9sUiqFyNNC
 JoMJb3Ht0FNFpSrkZMmRwcCI+DORtUYaJIgkgqZe8TDjLWDlm4
 kIoeBuTQUN7mwFcxe15RA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 November 2010 02:45:33 Ian Kent wrote:

> You can't hold an exclusive mutex during an autofs expire because the
> daemon will start by calling the ioctl to check for a dentry to expire
> then call back to the daemon to perform the umount and wait for a status
> return (also an ioctl).

Ok, I see. So it's my fault for not realizing that there are long blocking
ioctls. I was under the assumption that all of these ioctl commands were
simple non-blocking commands.

> >From memory the expire is the only ioctl that is sensitive to this
> deadlock.
> 
> So, either the mutex must be released while waiting for the status
> return or get rid of the autofs4_ioctl_mutex altogether.

Right. As I said with the original patch, I don't think the mutex
is really needed, but using it seemed to be the safer alternative.
It was in the sense that it guaranteed the breakage to be obvious
rather than silent...

Ian, if you can prove that the lock is not needed, I think we shold
just remove it.

	Arnd
