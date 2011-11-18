Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab1KRWvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:51:05 -0500
Received: from mail176c2.megamailservers.com ([69.49.111.76]:53074 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab1KRWvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:51:03 -0500
X-Authenticated-User: konrad.gaisler.com
Message-ID: <4EC6E179.1030703@gaisler.com>
Date: Fri, 18 Nov 2011 23:51:37 +0100
From: "konrad.gaisler" <konrad@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org,
        linux kbuild list <linux-kbuild@vger.kernel.org>, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com> <4EC69F65.20207@xenotime.net>
In-Reply-To: <4EC69F65.20207@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=nzisDwsushzt7gU+UbbGT+7gaUmTco5i81mmV/NoaDo= c=1 sm=1
		a=nFJ2T2qeKKUA:10 a=wd-vcygihCUA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=2wAOqaBLMYbCqLQOYtKPHg==:17 a=VwQbUJbxAAAA:8 a=ebG-ZW-8AAAA:8
		a=FAXIp6hDv2bdCbhm5ukA:9 a=wPNLvfGTeEIA:10 a=xQdB8fRqRzQA:10
		a=cCYF7-FHeg4A:10 a=NWVoK91CQyQA:10 a=2wAOqaBLMYbCqLQOYtKPHg==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 07:09 PM, Randy Dunlap wrote:
> (changed linux-config@ to linux-kbuild@vger.kernel.org)
>
> On 11/18/2011 06:16 AM, Konrad Eisele wrote:
>> New kconfig command "subsource":
>> subsource "<kconfig>""<cwd>""<.config>""<title>"<internal_prefix>  <.config_prefix>
>> Allocates<kconfig>  as a configuration subtree using<.config>  as the configuration
>> file to save and load from.<cwd>  is the directory path to switch to for "source" to
>> work, "<title>" is the Menu tile of the subtree,<internal_prefix>  is a internal prefix,
>> and<.config_prefix>  is the prefix to append/remove when saving/loading<.config>.
> That explains what but not why.  You need some justification(s) for such
> a large patch.  Maybe even some example usages.
The patch originated from a buildsystem that uses buildroot and linux.
Both use Kconfig and the buildsystem itself uses Kconfig. To configure
a subproject you have to exit the toplevel Kconfig and restart to
startup a subproject Kconfig, It is even more anoying when looking
inside buildroot. It has in its turn subprojects uClibc, busybox,
linux, crosstools-ng which all use Kconfig. The subtree patch
does make it possible to unify all in one Kconfig.

As an example, apply the patch, then add to <top>/Kconfig the lines:

subsource "arch/sparc/Kconfig" "." ".config_sparc" "SPARC config" SPARC_ 
CONFIG_
subsource "arch/mips/Kconfig" "." ".config_mips" "MIPS config" MIPS_ CONFIG_
(my mailclient breaks up the lines, it should be 2 lines only).

Then start "make xconfig" once to build "qconfig". The patch adds an
extra option to qconfig (also mconfig, gconfig and nconfig) "-s". This
option enables the "subsource" tag. Now start qconfig:
$<path-to-qconfig>/qconfig -s Kconfig

Then you see a subtree "Sparc config" and "Mips config" that is a sparc
and mips complete Kconfig. They are independent from another. The Sparc
subtree is saved/loaded from .config_sparc, the  Mips subtree is
saved/loaded from .config_mips. No namespace clash.

Note that without the "-s" option the Kconfig behaviour is as usual. I
think it would be a help for many projects that use Kconfig.

-- Konrad





>
>> Signed-off-by: Konrad Eisele<konrad@gaisler.com>
>> ---
>>   scripts/kconfig/conf.c               |    6 +-
>>   scripts/kconfig/confdata.c           |   83 ++-
>>   scripts/kconfig/expr.h               |   16 +
>>   scripts/kconfig/gconf.c              |    3 +
>>   scripts/kconfig/lkc.h                |    1 +
>>   scripts/kconfig/lkc_proto.h          |   12 +-
>>   scripts/kconfig/mconf.c              |   13 +-
>>   scripts/kconfig/menu.c               |   18 +-
>>   scripts/kconfig/nconf.c              |   13 +-
>>   scripts/kconfig/qconf.cc             |    3 +
>>   scripts/kconfig/symbol.c             |   50 ++-
>>   scripts/kconfig/util.c               |   49 ++
>>   scripts/kconfig/zconf.gperf          |    1 +
>>   scripts/kconfig/zconf.hash.c_shipped |  252 +++++-----
>>   scripts/kconfig/zconf.l              |   50 ++-
>>   scripts/kconfig/zconf.lex.c_shipped  |   52 ++-
>>   scripts/kconfig/zconf.tab.c_shipped  |  985 ++++++++++++++++++----------------
>>   scripts/kconfig/zconf.y              |   23 +-
>>   18 files changed, 991 insertions(+), 639 deletions(-)
>
>

