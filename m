Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1LAMpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:45:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1LAMpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:45:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: Re: Which one corresponds to ioctl in the file_operations struct in linux/fs.h?
Date: Thu, 1 Dec 2011 12:45:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Peng Yu <pengyu.ut@gmail.com>, linux-kernel@vger.kernel.org
References: <CABrM6wnDgRd0N5eSGffj51KR6-axAoFMNRWMZs2pFQ8dN94t0A@mail.gmail.com> <201112011022.12686.tvrtko.ursulin@onelan.co.uk>
In-Reply-To: <201112011022.12686.tvrtko.ursulin@onelan.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011245.16461.arnd@arndb.de>
X-Provags-ID: V02:K0:x1TQgwDjEsG6oYH2/CXjb3IKrEoUT6UGACBOXmbwB4z
 W8dvHoiTqPorbFUqTGMTv1mJcQ0vEVGWga6T2wF+Foo85ZHP0V
 zrXbEJoQ6Llyf/bNMQpiyRtRnypqC2+JyQamBTcGkimQA0ZfWB
 wHWLsHUEdFM1l9CEUThvlcyuTBBRcrz3DB1e32HqXUGZyZTC/k
 Vxcd+iqdwi+++d3QVJ5td+XI5i8cPBmI4bo6hT8KJKtH9OP5/L
 6jEJBkNILfVz6RYE383FD3zQJFB9e+Mdq4PR4R/7/YmO0tGaOY
 QDYimulPv5AgEpUN4HblRXtrYcePOuw50V3QDUhlnSFjvDAhUl
 PdVO5rUFDeD8HFxKjp1s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 December 2011, Tvrtko Ursulin wrote:
> On Thursday 01 Dec 2011 07:40:49 Peng Yu wrote:
> > Hi,
> > 
> > I have some driver code for older version of kernel. It refers to
> > ioctl in the file_operations struct. But this field is change in
> > kernel 3.0.0-13
> > 
> > I find the following in linux/fs.h
> > 
> > 1566   long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> > 1567   long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
> > 
> > Does anybody know which one I should use in order to migrate the
> > driver code to the newer version of kernel? Thanks!
> 
> From Documentation/filesystems/vfs.txt:
> 
>   unlocked_ioctl: called by the ioctl(2) system call.
> 
>   compat_ioctl: called by the ioctl(2) system call when 32 bit system calls
>          are used on 64 bit kernels.
> 
> You don't need compat_ioctl if your ioctl arguments are 32/64-bit safe.

Actually, you should always provide a .compat_ioctl pointer, but if
all commands are 32/64 bit safe, it can point to the same function,
or (slightly safer) be a wrapper like

static long my_compat_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
	return my_ioctl(f, cmd, (unsigned long)compat_ptr(arg));
}

Strictly speaking, the first option assumes that all commands
take no argument or integers directly encoded in the 'arg', while
the second option assumes that all commands take either no argument
or a pointer to an argument in memory.

	Arnd
