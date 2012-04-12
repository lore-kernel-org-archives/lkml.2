Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642Ab2DLT3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:29:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43665 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934629Ab2DLT3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120412131037.5371c8b0d9e2dde32e06f8ce@canb.auug.org.au>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
 <CA+55aFy-CeLXstbceP7+co3AXrEWtifKF+8NWzhC7B-A8xBd-w@mail.gmail.com>
 <CA+55aFx6V_TpbghsG7xqoBree8ALAKWMA+qLeGg-8DNAno+peg@mail.gmail.com>
 <20120411184538.ec21844a.akpm@linux-foundation.org> <CA+55aFx9WXtF7LT9rHv0=e0jqAq+b1cDPcRzSGDKvy7+XjxxtA@mail.gmail.com>
 <20120412131037.5371c8b0d9e2dde32e06f8ce@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Apr 2012 12:29:11 -0700
X-Google-Sender-Auth: fPb9b5mlgNKH4lt8XjaJOdpbuJA
Message-ID: <CA+55aFx15+eHNA4LobwiFhe4k94XPTVTLdiBmuR4hDKR5HpWPg@mail.gmail.com>
Subject: Re: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, tony@bakeyournoodle.com, mmarek@suse.cz,
        lacombar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 8:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Can we leave the CONFIG_ part in the caller, so they are still grepable, please?
>
> So:
>
>        #define config_enabled(x)       (__stringify(x)[0] == '1')

Sure. Except G+ came through, and we now have an even better hack for
this, that works entirely in the preprocessor.

That also means that you can use it for static initializers etc, so you can do

   int some_value = config_enabled(CONFIG_ENABLE_XYZ_BY_DEFAULT);

Paul, do you want to write the patch to change IS_ENABLED() to use this trick?

Trick courtesy of "comex ." on G+ (please do give him credit even if
he doesn't seem to use his real name):

  #define is_set(macro) is_set_(macro)
  #define macrotest_1 ,
  #define is_set_(value) is_set__(macrotest_##value)
  #define is_set__(comma) is_set___(comma 1, 0)
  #define is_set___(_, v, ...) v

and now "is_set(CONFIG_xyzzy)" works, and gives either 1 or 0 directly
in the preprocessor.

Obviously the names have to be changed here (let's not use
"macrotest_1" - make it something more internal), but the concept is
solid, and I would actually suggest having this as a generic "is this
macro set to 1" helper first, and then implement IS_ENABLED() in terms
of that.

My likee.

                       Linus
