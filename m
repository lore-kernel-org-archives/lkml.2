Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0HQNPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:15:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0HQNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:15:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] init/do_mounts.c: replace sys_mount() to do_mount()
Date: Tue, 17 Aug 2010 15:15:26 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1282048643-2475-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282048643-2475-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171515.26175.arnd@arndb.de>
X-Provags-ID: V02:K0:28v/CL1L8OOFGx5OmWzNpb2yT5Hz4i4bGsIK+YjxKKp
 28H+QfXyPzg1XbH8bZOtZV1bsI/VakY7rc9D8IN9hHgWOZ3YNP
 jh9vRrOKid6IRAxBTFywkvuNgPjWRdXX5fRzsms1qfsWbhqKsp
 zAXErXlow1KoLdN4Y5Cx0YwgQVawBS+iBiCMDeLJYqrdfS5ga5
 ZzArB2xiwR5ZHFcrs9gPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010, Namhyung Kim wrote:
>  static int __init do_mount_root(char *name, char *fs, int flags, void *data)
>  {
> -       int err = sys_mount(name, "/root", fs, flags, data);
> +       int err;
> +       unsigned long data_page = 0;
> +
> +       if (data) {
> +               /* data should be in a page */
> +               data_page = __get_free_page(GFP_KERNEL);
> +               if (!data_page)
> +                       return -ENOMEM;
> +               strlcpy((char *) data_page, data, PAGE_SIZE);
> +       }
> +
> +       err = do_mount(name, "/root", fs, flags, (void *) data_page);
> +
> +       if (data_page)
> +               free_page(data_page);

AFAICT there is no need for the copy at all here. The reason that sys_mount
copies to a separate page is that it gets passed an arbitrary-length user
input.

	Arnd
