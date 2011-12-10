Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab1LJGDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 01:03:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58939 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1LJGDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 01:03:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAMP44s1gZKKO_BPDcKzsk3hd4ob=S=6UuE0GE6JwwSjC0YSajw@mail.gmail.com>
References: <CAMP44s1gZKKO_BPDcKzsk3hd4ob=S=6UuE0GE6JwwSjC0YSajw@mail.gmail.com>
Date: Sat, 10 Dec 2011 08:03:21 +0200
Message-ID: <CAMhs6YxAQH+xzw72cmA7NjwYGD0qkOa4G0QHa7WwVWEt0xoFvw@mail.gmail.com>
Subject: Re: Is there something like MODULE_DEPEND?
From: Maxin B John <maxin.john@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Sat, Dec 10, 2011 at 6:08 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Hi,
>
> So I've finally found that my problem was that I have to load module
> B, before loading module A. The dependency is in the Kconfig file, but
> module A doesn't use any symbols from module B, so it's not
> automatically loaded.

>From this, I think  you are looking for the "request_module()".

> Apparently FreeBSD has a macro named MODULE_DEPEND for that, which
> would make sense.
>
> After reading some code, it seems to me that there's no easy way to
> achieve this, as by default there are no symbols that can be found by
> modpost, so something like this is needed:
>
>  const const char *module_b;
>  EXPORT_SYMBOL(module_b);
>
> note: KBUILD_MODNAME can't be used.
>
> And then, use it in module A:
>
>  extern const char *module_b;
>  static const char **test __used = &module_b;
>
> But ultimately, all we want is to add "module_b" to the "depends"
> field in the .modinfo section. It should be relatively easy to achieve
> by having a special section modpost can detect, and then just put it
> into "depends".
>
> Apparently I'm not the first one to have this need[1], but I wonder
> why not more people have it.
> [1] http://article.gmane.org/gmane.linux.kernel/1183905/match=module_depend
>
> --

Eg:

This "bare minimum" module should load "nfs" along with it.
---
#include <linux/module.h>
#include <linux/kernel.h>

int init_module(void)
{
        request_module("nfs");
        return 0;
}

void cleanup_module(void)
{

}

MODULE_LICENSE("GPL");
---
$ sudo insmod test.ko
$ lsmod|grep nfs
nfs                   275462  0
nfs_acl                 2257  1 nfs
lockd                  65605  1 nfs
fscache                46361  1 nfs
auth_rpcgss            34001  1 nfs
sunrpc                193146  5 nfs,nfs_acl,lockd,auth_rpcgss


> Felipe Contreras

Is this what you are looking for or I missed your point ?

HTH,
Maxin B. John
