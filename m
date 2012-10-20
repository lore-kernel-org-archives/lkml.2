Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2JTWTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:19:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45731 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2JTWTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:19:08 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] menuconfig: Replace CIRCLEQ by list_head-style lists.
Date: Sun, 21 Oct 2012 00:19:03 +0200
User-Agent: KMail/1.13.5 (Linux/3.6.2-treguer; KDE/4.4.5; x86_64; ; )
Cc: Benjamin Poirier <benjamin.poirier@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Jean Sacren <sakiwit@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Yaakov Selkowitz <yselkowitz@gmail.com>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr> <1350755792-21217-1-git-send-email-benjamin.poirier@gmail.com>
In-Reply-To: <1350755792-21217-1-git-send-email-benjamin.poirier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210210019.04263.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, All,

On Saturday 20 October 2012 Benjamin Poirier wrote:
> From: Benjamin Poirier <bpoirier@suse.de>
> 
> sys/queue.h and CIRCLEQ in particular have proven to cause portability
> problems (reported on Debian Sarge, Cygwin and FreeBSD)
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Sorry for my earlier optimistic reply, but...

While menuconfig got fixed with this patch, xconfig is now broken:

First issue:
In file included from /home/ymorin/dev/linux/scripts/kconfig/expr.h:15,
                 from /home/ymorin/dev/linux/scripts/kconfig/lkc.h:9,
                 from /home/ymorin/dev/linux/scripts/kconfig/qconf.cc:45:
/home/ymorin/dev/linux/scripts/kconfig/list.h:8:1: warning: "offsetof"
redefined
In file included from /usr/include/_G_config.h:15,
                 from /usr/include/libio.h:32,
                 from /usr/include/stdio.h:75,
                 from /usr/include/qt4/QtCore/qtextstream.h:57,
                 from /usr/include/qt4/Qt3Support/q3mainwindow.h:47,
                 from /home/ymorin/dev/linux/scripts/kconfig/qconf.cc:19:
/usr/lib/gcc/x86_64-linux-gnu/4.4.5/include/stddef.h:411:1: warning: this
is the location of the previous definition

[--SNIP--]
> diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
> new file mode 100644
> index 0000000..934bdba
> --- /dev/null
> +++ b/scripts/kconfig/list.h
> @@ -0,0 +1,90 @@
> +#ifndef LIST_H
> +#define LIST_H
> +
> +/*
> + * Copied from include/linux/...
> + */
> +
> +#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)

We could #include <stddef.h>, but then we may end up with issues with
old systems (which we are trying to fix!). I suggest we enclose the
definition between a 
    #ifndef offsetof
    ...
    #endif


Second issue:
We have further issues with some variable names:
/home/ymorin/dev/linux/scripts/kconfig/list.h:69: error: expected ‘,’ or
‘...’ before ‘new’

[--SNIP--]
> +static inline void __list_add(struct list_head *new,

'new' is a reserved key-word in C++, and xconfig is using qconf, which is
written in C++.

I 'd suggest to:
 1- rename the variable
 2- enclose the whole header in:
    #ifdef __cplusplus
    extern "C" {
    #endif
    [.....]
    #ifdef __cplusplus
    }
    #endif

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
