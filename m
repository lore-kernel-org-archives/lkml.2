Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab2ITOZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:25:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab2ITOYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:24:51 -0400
Message-ID: <505B272A.3000705@suse.de>
Date: Thu, 20 Sep 2012 10:24:42 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH[ Makefile: Fix scripts_basic / archscripts build order
References: <505A02F8.4040804@suse.de> <505A03EC.8090502@linux.intel.com>
In-Reply-To: <505A03EC.8090502@linux.intel.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/19/12 1:42 PM, H. Peter Anvin wrote:
> Kbuild people, any comments?

Thanks for bouncing along.

This patch is wrong. It fixes the 'make' case because scripts_basic is
build before archscripts but doesn't get rid of the root cause.

'make archscripts' alone still fails. I'll send a replacement that
addresses that dependency issue directly.

- -Jeff

> On 09/19/2012 10:38 AM, Jeff Mahoney wrote:
>> The SUSE kernel packages are built by doing the following:
>> 
>> make silentoldonfig make prepare make scripts make clean
>> 
>> <capture file list used for building modules>
>> 
>> make -j$NCPUs
>> 
>> On parallel builds (also using -C/O=), this can occasionally fail
>> with: HOSTCC  scripts/basic/fixdep /bin/sh: scripts/basic/fixdep:
>> No such file or directory make[3]: *** [arch/x86/tools/relocs]
>> Error 1 make[2]: *** [archscripts] Error 2 make[2]: *** Waiting
>> for unfinished jobs.... make[1]: *** [sub-make] Error 2 make: ***
>> [all] Error 2
>> 
>> The error can also be "Permission denied."
>> 
>> Without the make clean this works ok.
>> 
>> What seems to be happening is that fixdep exists so relocs is
>> able to be rebuilt, but then somewhere there is a FORCE rule that
>> applies to fixdep so it is rebuilt. If the timing is right, the
>> relocs build can happen while the fixdep rebuild is happening and
>> we either get a non-executable fixdep or a nonexistent fixdep.
>> 
>> This patch moves the archscripts dependency after scripts_basic
>> so that fixdep is always built after relocs. If I understand the
>> build order correctly, this should be the case since
>> scripts_basic is essentially a prereq of everything.
>> 
>> This was introduced by commit 6520fe55 (x86, realmode: 16-bit
>> real-mode code support for relocs), which added the archscripts
>> dependency to archprepare.
>> 
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- Makefile |    2
>> +- 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> --- a/Makefile +++ b/Makefile @@ -835,7 +835,7 @@ prepare1:
>> prepare2 include/linux/version include/config/auto.conf 
>> $(cmd_crmodverdir)
>> 
>> -archprepare: archheaders archscripts prepare1 scripts_basic 
>> +archprepare: archheaders scripts_basic archscripts prepare1
>> 
>> prepare0: archprepare FORCE $(Q)$(MAKE) $(build)=.
>> 
> 
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQWycqAAoJEB57S2MheeWyrOcP/1zkI9gwRCwjGhzd78177JHZ
6YFAkg3bTfQjCKrb1uU414wlFyRS+yHV2TlSDk4UTFfXMM7Y1FKmhGVF2ZJF2EBs
FNOXnRFwh4zhcztXtrSNqs1omhAEfS9FBGlwOmSdSg+mMSK6cAoK2krQuEsrTYUR
9uTeJfvfOJJgTHw5+jM6HH17swF2MkhwS/C5cBt3qGc4keE/+YL7Ub8DRIcrwMN3
1ux87W7Y2e1PaPcxDufZnryMkOSq8IOmRB1ErdJ1fCRcoE3RG5esrrbULURscA3b
OS5+mhJZj8Q5GlFYm1zrKNVxN973nsdw80d6QSGLU6oMtDEF7Hei4fg+KPzgFHNy
Q+Cqt/il1onehS/aMxcjU9OdOPObMau5OVzDv3n+EYnR1wUW7nRevtUt4eVsYG4Z
qEy50tHuv8AO+sfB3nVC268sHOteUwqDDWKJC/vRMnJ4tKHi/vNJinweXzb1G+lp
O/Q2em0zBqmSnBsnlxhk+Ga4riBkcBsHtBiPFZ7NFpXrSXj93ASAURnlRFvpFa/u
mGz/izuFx9s1FFWAfjLMC+LtlMndr4p0DYa2tODt72+HibVA435JMsKSQL8s8fji
HdBJux8MOJzjBqic6y3lHyJKwpjXBB6zNqxr0WNocvwJiS5mEBERpDc4JQp+DCI6
EJV+7rUH8MDw5w69+e2f
=rC/d
-----END PGP SIGNATURE-----
