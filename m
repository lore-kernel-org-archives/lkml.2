Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1B0Xnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:43:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1B0Xnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:43:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 05/12] unicore32 additional architecture files: low-level lib: uaccess
Date: Sun, 27 Feb 2011 18:21:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <014b01cbcdad$f110afb0$d3320f10$@mprc.pku.edu.cn> <201102171845.01177.arnd@arndb.de> <017b01cbd62d$633fd070$29bf7150$@mprc.pku.edu.cn>
In-Reply-To: <017b01cbd62d$633fd070$29bf7150$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102271821.34017.arnd@arndb.de>
X-Provags-ID: V02:K0:YO8yQ/ZdfkTLhaTQTAz0KRNVA1XJcOZx9nj5XxtEHOT
 eIWBNNYoBqBxuLWGZUk9HuNKpqh6OB7QMcDao+9ZUlzQ6LdHND
 g5m10GomuvY0yQvcB42zO6EhUDgWwHggjIUx5aH6gsrHFzAeJ9
 YupzrXv5xEdh3OvlNPI+CEN52IM3kFikAkxU9tsjjs//HEQpZU
 u32wpPC3aQExDWinJYUkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Guan Xuetao wrote:
> > -----Original Message-----
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > Sent: Friday, February 18, 2011 1:45 AM
> > To: Guan Xuetao
> > Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> > Subject: Re: [PATCH 05/12] unicore32 additional architecture files: low-level lib: uaccess
> > 
> > On Wednesday 16 February 2011, Guan Xuetao wrote:
> > > +
> > > +#define __kernel_ok                (segment_eq(get_fs(), KERNEL_DS))
> > > +#define __user_ok(addr, size)      (((size) <= TASK_SIZE)                  \
> > > +                           && ((addr) <= TASK_SIZE - (size)))
> > > +#define __access_ok(addr, size)    (__kernel_ok || __user_ok((addr), (size)))
> > 
> > A nice trick to simplify this is to introduce a per-process variable for comparing
> > the pointer, set_fs() then sets this variable to either TASK_SIZE or
> > UINT_MAX.
> 
> Perhaps like this:
> 1. add a member named kaddr in thread_info
> 2. add following assignment codes in set_fs:
>         current_thread_info()->kaddr =  segment_eq(fs, KERNEL_DS) ? UINT_MAX : TASK_SIZE;
> 3. then __access_ok will be:
>         #define addr 
>         #define __access_ok(addr, size)   (((size) <= TASK_SIZE)                        \
>                                 && ((addr) <= current_thread_info()->kaddr)  - (size)))

That would also work. What I meant was to have

#define set_fs(fs) \
	do { current_thread_info()->kaddr = (fs); } while (0)

#define KERNEL_DS	UINT_MAX
#define USER_DS		TASK_SIZE

Either way is fine with me, just choose whichever works best for you in terms of code size.

	Arnd

