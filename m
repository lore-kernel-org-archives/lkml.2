Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab2HXKKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:10:44 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:51060 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab2HXKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:10:40 -0400
Message-ID: <50375302.1050603@halfdog.net>
Date: Fri, 24 Aug 2012 10:10:10 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14a1
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Search for patch for kernel stack data disclosure in binfmt_script
 during execve
References: <502FA000.8090700@halfdog.net> <5030A65D.90305@halfdog.net> <503553EF.1090508@halfdog.net> <20120823085625.GA4683@otc-wbsnb-06>
In-Reply-To: <20120823085625.GA4683@otc-wbsnb-06>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kirill A. Shutemov wrote:
> On Wed, Aug 22, 2012 at 09:49:35PM +0000, halfdog wrote:
>> Got a hint via IRC, that I should not send patch idea for review 
>> to "generic" list, but to maintainers and last (or relevant) 
>> comitters of code.
>> 
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=bf2a9a39639b8b51377905397a5005f444e9a892
>>
>> 
...
>> halfdog wrote:
>>> halfdog wrote:
>>>> I'm searching for a patch for linux kernel stack disclosure 
>>>> in binfmt_script with crafted interpreter names when 
>>>> CONFIG_MODULES is active (see [1]).
>>> 
>>> Please disregard my previous proposal [2], since it did not 
>>> address the problem directly (referencing local stack frame 
>>> data from bprm structure) but worked around it. I suspect,
>>> that this could increase probability to reintroduce similar
>>> bugs.
>>> 
>>> Opinions on (untested sketch for) second solution: Could 
>>> someone look on the source code comments and changes in patch 
>>> to judge, if this is going in the right direction?
>>> 
>>> Explanation of patch: Since load_script will start to 
>>> irreversibly change bprm structures at some point (using stack 
>>> local data was one of those changes), try to delay this point. 
>>> Run checks if load_script could be the right handler, if not 
>>> give other binfmt handlers the chance to do so.
>>> 
>>> If binfmt_script is the right one, try to load the interpreter
>>>  (causing bprm modification), if failing make sure that no
>>> other binfmt handler has the chance to continue on the now
>>> modified bprm data.
>>> 
>>> CAVEAT: This assumes, that if binfmt_script could handle the 
>>> load, that it would be the one and only binfmt with that 
>>> ability, so no other one, e.g. binfmt_misc should have the 
>>> chance to do so. If this assumption is wrong, leaving 
>>> binfmt_script would have to rollback all bprm changes (e.g. 
>>> restore old credentials).
>>> 
>>> [1]
>>> http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/
>>>
>>> 
[2] http://lkml.org/lkml/2012/8/18/75
> 
> What about (untested):
> 
> diff --git a/fs/exec.c b/fs/exec.c index 574cf4d..ef13850 100644 
> --- a/fs/exec.c +++ b/fs/exec.c @@ -1438,7 +1438,8 @@ int 
> search_binary_handler(struct linux_binprm *bprm,struct pt_regs 
> *regs) } read_unlock(&binfmt_lock); #ifdef CONFIG_MODULES -		if 
> (retval != -ENOEXEC || bprm->mm == NULL) { +		if (retval != 
> -ENOEXEC || bprm->mm == NULL || +				bprm->recursion_depth > 
> BINPRM_MAX_RECURSION) { break; } else { #define printable(c) 
> (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))

- - From my understanding, this patch should not fix the problem, since
recursion depth is reset back to old value after call of binfmt handler.
This is done, so that fs/exec does not have to trust all binfmts to
reset the depth by themselfes when leaving.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=blob;f=fs/exec.c;h=da27b91ff1e8cbe87d0fe42aa5d39513e6a9deeb;hb=HEAD
   1408                         read_unlock(&binfmt_lock);
   1409                         retval = fn(bprm, regs);
   1410                         /*
   1411                          * Restore the depth counter to its
starting value
   1412                          * in this call, so we don't have to
rely on every
   1413                          * load_binary function to restore it on
return.
   1414                          */
   1415                         bprm->recursion_depth = depth;


I guess, the problem is, that recursion_depth usually not only limits
the depth, but also the maximal number of binfmt_xxx calls. That's why,
the use of local stack-frame data in bprm does not matter, there is no
going up the stack AND using bprm->interpreter, the last error is
terminates the search.

In the POC, search is not terminated because of ENOEXEC when max depth
reached and due to special filename, mod-loader triggers also (about 30
times? I do not known, if that could be a problem also, interfering with
other module loads. Usually non-root users cannot trigger rapid module
loads easily).

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlA3U3QACgkQxFmThv7tq+7hTgCZAcQFn70FUWnAhvoMYhm8EcFT
8vQAn06VtbeY5P0cPGd9fcxL6AaEF8oS
=An9g
-----END PGP SIGNATURE-----
