Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0H3MMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:12:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab0H3MMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:12:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC v2 PATCH 1/3] init: add sys-wrapper.h
Date: Mon, 30 Aug 2010 14:11:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1283102928-3051-1-git-send-email-namhyung@gmail.com> <1283102928-3051-2-git-send-email-namhyung@gmail.com>
In-Reply-To: <1283102928-3051-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301411.43910.arnd@arndb.de>
X-Provags-ID: V02:K0:nqJbyQae7Cpk8LqzLoehU5LwVZr4y+XTM3gm8L1Tmhw
 V6H/pja2W3S1cOcBpHfab/C/gdLoFK49c4kXqOMtiNnqltQP4T
 UJYp8zRsbz/FktoAc5LIBqiK8nC7PX/WJ8D8Ao1vY4qvYHpXq1
 c9yhxXOopIAA0opwJOjr5QZa9gRg6qboEQ5GPqAZlLUZRcq9oG
 zag+1G3p1YqIEpvUnzA8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 August 2010, Namhyung Kim wrote:
> +
> +/* These macro are called just before/after actual syscalls. */
> +#define KSYS_PREPARE				\
> +	mm_segment_t old_fs = get_fs();		\
> +	set_fs(KERNEL_DS);
> +
> +#define KSYS_RESTORE				\
> +	set_fs(old_fs);

These macros are not that nice, because they depend on context.
I would probably open-code them in each function, or possibly
use a single macro to combine it to something like

#define kern_sys_call(call, ...)	\
({					\
	mm_segment_t old_fs = get_fs();	\
	long result;			\
	set_fs(KERNEL_DS);		\
	result = call(__VA_ARGS__);	\
	set_fs(old_fs);			\
	result;				\
})

static inline int kern_sys_link(const char *oldname, const char *newname)
{
	return kern_sys_call(sys_link, (const char __user __force *)oldname,
			     (const char __user __force *)newname);
}

> +static inline int kern_sys_fchown(unsigned int fd, uid_t user, gid_t group)
> +{
> +	int ret;
> +	KSYS_PREPARE;
> +
> +	ret = sys_fchown(fd, user, group);
> +
> +	KSYS_RESTORE;
> +	return ret;
> +}

When there are no pointer arguments, there is no need to do set_fs
tricks.

	Arnd
