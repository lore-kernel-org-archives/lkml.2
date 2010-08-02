Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0HBV3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:29:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab0HBV3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:29:36 -0400
Message-ID: <4C5738BC.4040608@suse.cz>
Date: Mon, 02 Aug 2010 23:29:32 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHi v3] kconfig qconf: port to QT4
References: <4C4D8348.5040802@suse.cz> <1280488517-30116-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
In-Reply-To: <1280488517-30116-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.7.2010 13:15, Alexander Stein wrote:
> A straight forward port to QT4 using qt3to4 and compiling against
>   qt3support
> 
> * rewritten makefile rules to detect QT4 by using qmake which is hopefully
>   portable enough

You are using pkg-config now.


> * If no QT4, QT3 will by tried instead
> * Classes renamed using qt3to4
>   * If build using QT3 renamed to QT3 class names using defines
> * ConfigInfoView::menu has to be renamed as QT4 moc strips struct from
>   struct menu and creates a name conflict
> * QT2 support has been dropped
> * The hidden options inserted in 39a4897c1bb66e8a36043c105d7fd73d8b32b480
>   are use in native API
> 
> Signed-off-by: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
> ---
> Changes in v2:
> * Use QT3 as fallback if no QT4 is available
> * Rename class names using defines for QT3
> 
> Changes in v3:
> * based on git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
>   kconfig branch

Thanks, that makes my life easier.


> * Proper support for hidden options from 39a4897c1bb
> * slightly rework Makefile detection to use pkg-config for QT4 detection
> * Removed USE_QT3 usage, use QT_VERSION instead
> * Drop QT2 support
> 
> Michael,
> 
> i kept using Q3Foo classes and redefine them to QFoo instead of the other way
> around, as defining QFoo to Q3Foo doesn't work here.

OK.


>  scripts/kconfig/Makefile |   77 +++++++++++++---------
>  scripts/kconfig/qconf.cc |  162 +++++++++++++++++++++++++---------------------
>  scripts/kconfig/qconf.h  |   76 ++++++++++-----------
>  3 files changed, 169 insertions(+), 146 deletions(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index f8d1ee3..a203a90 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -233,40 +233,51 @@ $(obj)/.tmp_qtcheck: $(src)/Makefile
>  # QT needs some extra effort...
>  $(obj)/.tmp_qtcheck:
>  	@set -e; echo "  CHECK   qt"; dir=""; pkg=""; \
> -	pkg-config --exists qt 2> /dev/null && pkg=qt; \
> -	pkg-config --exists qt-mt 2> /dev/null && pkg=qt-mt; \
> -	if [ -n "$$pkg" ]; then \
> -	  cflags="\$$(shell pkg-config $$pkg --cflags)"; \
> -	  libs="\$$(shell pkg-config $$pkg --libs)"; \
> -	  moc="\$$(shell pkg-config $$pkg --variable=prefix)/bin/moc"; \
> -	  dir="$$(pkg-config $$pkg --variable=prefix)"; \
> +	pkg-config --exists QtCore 2> /dev/null; \
> +	if [ ! $? ]; then \

A couple of issues here: 1) The script is running under set -e, so if
there is no Qt4, it will exit right away. 2) The '$?' is interpreted by
make, you need to say '$$?' if you want the shell see '$?'. Last but not
least, there is no C-style arithmetics in the [ builtin, [ ! 0 ] and [ !
1 ] will both evaluate to failure. You probably meant [ $$? -ne 0 ], but
it still wouldn't work because of 1). Just use

  if ! pkg-config --exists QtCore 2> /dev/null; then
    ... qt 3 ...
  else
    ... qt 4 ...
  fi

When I fix it manually, it works OK both under Qt4 and Qt3, which is
great, but please submit a patch that you tested yourself. If you're
quick (but not too quick to omit testing), I'll push it in this merge
window.

thanks,
Michal
