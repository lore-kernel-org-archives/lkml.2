Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1KSHzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 02:55:08 -0500
Received: from mail202c2.megamailservers.com ([69.49.111.103]:58846 "EHLO
	mail202c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1KSHzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 02:55:06 -0500
X-Authenticated-User: konrad.gaisler.com
Message-ID: <4EC7610A.3040807@gaisler.com>
Date: Sat, 19 Nov 2011 08:55:54 +0100
From: "konrad.gaisler" <konrad@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-config@vger.kernel.org, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com> <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
In-Reply-To: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=t6P6ZnH7F4B+FTDzBT2sv7Wly1PyMf9jGdjNuUfj6/c= c=1 sm=1
		a=nFJ2T2qeKKUA:10 a=wd-vcygihCUA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=2wAOqaBLMYbCqLQOYtKPHg==:17 a=ebG-ZW-8AAAA:8 a=VwQbUJbxAAAA:8
		a=W0vUJOdyAAAA:8 a=c7nLZFSG2UNxjhw0DXEA:9 a=IbbPQ2CKiS61GXE1RxsA:7
		a=wPNLvfGTeEIA:10 a=xQdB8fRqRzQA:10 a=x8gzFH9gYPwA:10 a=cCYF7-FHeg4A:10
		a=NWVoK91CQyQA:10 a=2wAOqaBLMYbCqLQOYtKPHg==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2011 07:15 AM, Arnaud Lacombe wrote:
> Hi,
>
> On Fri, Nov 18, 2011 at 9:16 AM, Konrad Eisele<konrad@gaisler.com>  wrote:
>> New kconfig command "subsource":
>> subsource "<kconfig>""<cwd>""<.config>""<title>"<internal_prefix>  <.config_prefix>
>> Allocates<kconfig>  as a configuration subtree using<.config>  as the configuration
>> file to save and load from.<cwd>  is the directory path to switch to for "source" to
>> work, "<title>" is the Menu tile of the subtree,<internal_prefix>  is a internal prefix,
>> and<.config_prefix>  is the prefix to append/remove when saving/loading<.config>.
>>
> Please break this down in logical change!
>
> There is very good stuff in this patch but it need to be digested slowly :)
>
> I'd see it as:
>   - introduce the config structure
>   - convert all globals reference to use structure members
>   - get rid of these `_level' prefix and NULL pointer passing.
>   - then introduce the subsource logic (and please separate parser
> update and regen of shipped file)
>
> There is no need for the `_level' prefixing, NULL pointer passing, and
> conditionally select the structure or the global. The sub-tree should
> be treated the same way as the global tree. Basically:
>
> -   if (!sym_defconfig_list) {
> +   if (!(l ? l->sym_defconfig_list : sym_defconfig_list)) {
>
> should just be:
>
> -   if (!sym_defconfig_list) {
> +   if (!l->sym_defconfig_list) {
>
> no extra complexity/un-maintainability. You may not even need to
> change function prototypes if the current tree never expect to use
> anything but `current_config'.
>
> On a performance p.o.v., you may want to have one commit caching the
> prefix length, to avoid all the strlen(...).
>
> on a pure stylistic side
>   - don't pass 0 when you mean NULL (well, you will no longer need that actually)
>   - loop with 6 level of indentation are hideous, especially for
> condition where you can just `break;' early

I'll prepare a new patch next week with your suggestion. Its
nice to hear that there is some interest in this.

-- Konrad



>
> Thanks,
>   - Arnaud
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

