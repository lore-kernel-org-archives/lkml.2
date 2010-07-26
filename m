Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0GZMp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:45:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:35749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0GZMpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:45:24 -0400
Message-ID: <4C4D8348.5040802@suse.cz>
Date: Mon, 26 Jul 2010 14:44:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kconfig qconf: port to QT4
References: <4C0D64A2.9020701@suse.cz> <1279049216-22480-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
In-Reply-To: <1279049216-22480-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.7.2010 21:26, Alexander Stein wrote:
> A straight forward port to QT4 using qt3to4 and compiling against
>   qt3support
> 
> * rewritten makefile rules to detect QT4 by using qmake which is hopefully
>   portable enough
> * If no QT4, QT3 will by tried instead
> * Classes renamed using qt3to4
>   * If build using QT3 renamed to QT3 class names using defines
> * ConfigInfoView::menu has to be renamed as QT4 moc strips struct from
>   struct menu and creates a name conflict

Hi Alexander,

first, one thing I forgot to mention: There are some changes by Li Zefan
in my kconfig branch, which conflict with your patch. I resolved the
conflicts myself (but see below), but could you please use the kconfig
or for-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git next
time? If you already have a clone of Linus's tree, then just do

$ git remote add kbuild \
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
$ git remote update kbuild
$ git checkout -b kconfig kbuild/kconfig

This will only download a few hundred kilobytes.

> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 7ea649d..eb3c2f6 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -233,40 +233,52 @@ $(obj)/.tmp_qtcheck: $(src)/Makefile
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
> +	qmake=$(shell which qmake); \
> +	if [ -z $$qmake ]; then \

Unfortunatelly, this doesn't work for me if I uninstall libqt4-devel and
use qt3-devel, because then I have:
$ qmake --version
Qmake version: 1.07a (Qt 3.3.8b)
Qmake is free software from Trolltech ASA.
$ which qmake
/usr/lib/qt3/bin/qmake

I'm using openSUSE 11.3, but I think this is a generic problem, qmake
existed before QT4.


> diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
> index b3b5657..3853ae8 100644
> --- a/scripts/kconfig/qconf.h
> +++ b/scripts/kconfig/qconf.h
> @@ -3,26 +3,25 @@
>   * Released under the terms of the GNU GPL v2.0.
>   */
>  
> +#ifdef USE_QT3
>  #include <qlistview.h>
> -#if QT_VERSION >= 300
> -#include <qsettings.h>
>  #else
> -class QSettings {
> -public:
> -	void beginGroup(const QString& group) { }
> -	void endGroup(void) { }
> -	bool readBoolEntry(const QString& key, bool def = FALSE, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return def; }
> -	int readNumEntry(const QString& key, int def = 0, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return def; }
> -	QString readEntry(const QString& key, const QString& def = QString::null, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return def; }
> -	QStringList readListEntry(const QString& key, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return QStringList(); }
> -	template <class t>
> -	bool writeEntry(const QString& key, t value)
> -	{ return TRUE; }
> -};
> +#include <q3listview.h>
> +#endif
> +#include <qsettings.h>

Here, you are removing compatibility code for pre-3.0.0 QT versions.
That's perfectly fine in 2010 :-), but could you also please mention it
in the changelog and remove the other occurences of this ifdef in qconf.cc?

Other than that, I haven't found other issues with *your* patch, but
when I merge it with 39a4897 (xconfig: add support to show hidden
options which have prompts) and work around the above Makefile issue, I get

QObject::connect: No such signal QActionGroup::selected(Q3Action*)
QObject::connect:  (sender name:   'unnamed')
QObject::connect:  (receiver name: 'config')
QObject::connect: No such signal QActionGroup::selected(Q3Action*)
QObject::connect:  (sender name:   'unnamed')
QObject::connect:  (receiver name: 'menu')

and the Option -> Show Normal/All/Promp options menu added by 39a4897
does not work. The problem is that the QT4 moc does not run the
preprocessor, so the Q3Action token is not replaced by QAction. The QT4
does not have this limitation anymore, so I was wondering: Instead of
renaming every single class name in the source and then defining the
names back for QT3, could we just define the classes to the Q3Foo
versions for the QT4 case? This would solve the issue with the QT3 moc
and also make the patch smaller.

Michal
