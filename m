Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2BQPPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:15:45 -0500
Received: from defer-dn03.ocn.ad.jp ([125.170.100.156]:48300 "EHLO
	defer-dn03.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2BQPPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:15:44 -0500
Date: Sat, 18 Feb 2012 00:14:05 +0900 (JST)
Message-Id: <20120218.001405.229654364.anemo@mba.ocn.ne.jp>
To: lacombar@gmail.com
Cc: mmarek@suse.cz, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kconfig: tristate choice with depender choice
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20120209.233017.47225051.anemo@mba.ocn.ne.jp>
References: <CACqU3MXdKti6J2ozx3mt3UHdhv1fyPredvT6zJGR+u_hNU70Cg@mail.gmail.com>
	<CACqU3MU6j0ed6C9QDfzuoH+2a-2hww2wrCsQXW-kUfK37iansQ@mail.gmail.com>
	<20120209.233017.47225051.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Feb 2012 23:30:17 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> I tested in this way:
> 
> 1. Add this example to the end of drivers/char/Kconfig file.
> -------------------------------------
> choice
> 	prompt "choice list AB"
> config A
> 	tristate "a"
> config B
> 	tristate "b"
> endchoice
> choice
> 	prompt "choice list CD"
> 	depends on A
> config C
>        	bool "c"
> config D
>        	bool "d"
> endchoice
> -------------------------------------
> 
> 2. Then run commands:
> 
> $ cp arch/x86/configs/i386_defconfig arch/x86/configs/test_defconfig
> $ echo 'CONFIG_A=y' >> arch/x86/configs/test_defconfig 
> $ make O=../build test_defconfig
> $ grep CONFIG_A= ../build/.config
> CONFIG_A=m

I did some investigations.
When this happens, sym_calc_value() was called recursively.

main
  conf_set_all_new_symbols
    sym_calc_value ("choice list CD")
      sym_calc_visibility ("choice list CD")
        expr_calc_value
          sym_calc_value ("A")

On this place in sym_calc_value(), sym->def[S_DEF_USER].tri was 'yes'
and sym->visible was 'mod'.

		newval.tri = EXPR_AND(sym->def[S_DEF_USER].tri,
				      sym->visible);
		goto calc_newval;

Then new value of CONFIG_A will be 'mod'.

I suppose sym->visible is 'mod' because default value of tristate
choice is 'mod'.  Is this correct?
Any suggestions for fixing or debugging?

---
Atsushi Nemoto
