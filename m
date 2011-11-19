Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1KSGPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 01:15:53 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63452 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1KSGPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 01:15:51 -0500
MIME-Version: 1.0
In-Reply-To: <1321625774-12749-1-git-send-email-konrad@gaisler.com>
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com>
Date: Sat, 19 Nov 2011 01:15:50 -0500
Message-ID: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
From: Arnaud Lacombe <lacombar@gmail.com>
To: Konrad Eisele <konrad@gaisler.com>
Cc: linux-kernel@vger.kernel.org, linux-config@vger.kernel.org, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 18, 2011 at 9:16 AM, Konrad Eisele <konrad@gaisler.com> wrote:
> New kconfig command "subsource":
> subsource "<kconfig>" "<cwd>" "<.config>" "<title>"  <internal_prefix> <.config_prefix>
> Allocates <kconfig> as a configuration subtree using <.config> as the configuration
> file to save and load from. <cwd> is the directory path to switch to for "source" to
> work, "<title>" is the Menu tile of the subtree, <internal_prefix> is a internal prefix,
> and <.config_prefix> is the prefix to append/remove when saving/loading <.config>.
>
Please break this down in logical change!

There is very good stuff in this patch but it need to be digested slowly :)

I'd see it as:
 - introduce the config structure
 - convert all globals reference to use structure members
 - get rid of these `_level' prefix and NULL pointer passing.
 - then introduce the subsource logic (and please separate parser
update and regen of shipped file)

There is no need for the `_level' prefixing, NULL pointer passing, and
conditionally select the structure or the global. The sub-tree should
be treated the same way as the global tree. Basically:

-   if (!sym_defconfig_list) {
+   if (!(l ? l->sym_defconfig_list : sym_defconfig_list)) {

should just be:

-   if (!sym_defconfig_list) {
+   if (!l->sym_defconfig_list) {

no extra complexity/un-maintainability. You may not even need to
change function prototypes if the current tree never expect to use
anything but `current_config'.

On a performance p.o.v., you may want to have one commit caching the
prefix length, to avoid all the strlen(...).

on a pure stylistic side
 - don't pass 0 when you mean NULL (well, you will no longer need that actually)
 - loop with 6 level of indentation are hideous, especially for
condition where you can just `break;' early

Thanks,
 - Arnaud

> Signed-off-by: Konrad Eisele <konrad@gaisler.com>
> ---
>  scripts/kconfig/conf.c               |    6 +-
>  scripts/kconfig/confdata.c           |   83 ++-
>  scripts/kconfig/expr.h               |   16 +
>  scripts/kconfig/gconf.c              |    3 +
>  scripts/kconfig/lkc.h                |    1 +
>  scripts/kconfig/lkc_proto.h          |   12 +-
>  scripts/kconfig/mconf.c              |   13 +-
>  scripts/kconfig/menu.c               |   18 +-
>  scripts/kconfig/nconf.c              |   13 +-
>  scripts/kconfig/qconf.cc             |    3 +
>  scripts/kconfig/symbol.c             |   50 ++-
>  scripts/kconfig/util.c               |   49 ++
>  scripts/kconfig/zconf.gperf          |    1 +
>  scripts/kconfig/zconf.hash.c_shipped |  252 +++++-----
>  scripts/kconfig/zconf.l              |   50 ++-
>  scripts/kconfig/zconf.lex.c_shipped  |   52 ++-
>  scripts/kconfig/zconf.tab.c_shipped  |  985 ++++++++++++++++++----------------
>  scripts/kconfig/zconf.y              |   23 +-
>  18 files changed, 991 insertions(+), 639 deletions(-)
