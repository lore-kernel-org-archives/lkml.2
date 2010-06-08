Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0FHKON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 06:14:13 -0400
Received: from daytona.panasas.com ([67.152.220.89]:2055 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753386Ab0FHKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 06:14:12 -0400
Message-ID: <4C0E17F0.5010902@panasas.com>
Date: Tue, 08 Jun 2010 13:14:08 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kbuild: Fix the breakage caused by "improve version string logic"
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DFFFF.1010704@panasas.com> <alpine.DEB.2.00.1006080200190.18052@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1006080200190.18052@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 10:14:10.0697 (UTC) FILETIME=[566C9F90:01CB06F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 12:13 PM, David Rientjes wrote:
> On Tue, 8 Jun 2010, Boaz Harrosh wrote:
> 
>>
>> The patch: 85a256d8e0116c8f5ad276730830f5d4d473344d
>> 	Author: David Rientjes <rientjes@google.com>
>> 	Title: kbuild: improve version string logic
>>
>> Broke none Linus trees that supply their own version string and
>> tag system via a presence of a localversion* file at the Kernel's
>> root subdirectory.
>>
>> After This patch. The "+" (plus) is not added if a localversion*
>> file is present or a CONFIG_LOCALVERSION is configured.
>>
> 
> The only reason the `+' is being appended to your version string is 
> because your scm is reporting that there have been commits to the tree 
> since the last release; for git, that means anything that isn't at a 
> tagged commit.
> 

What is a tagged commit:

[my_tree] $ git branch
*master
[my_tree] $ git tag v2.6.35-rc2-my-tree
[my_tree] $ cat localversion-my-tree
-my-tree

I still get: DEPMOD 2.6.35-rc2-my-tree+

How to solve? please specify.

> If you were to create a tarball of your tree, for instance, and distribute 
> it to someone else, there would be no appended `+' because there is no 
> revision history.  The `+' being appended simply implies that you're 
> beyond the base kernel version in an scm.  The motivation is to be more 
> descriptive about what kernel is being run: the most common case where 
> this comes into play is when someone is running a kernel off of Linus' 
> tree and a bug report incorrectly shows that it is a vanilla 2.6.35-rc2 
> kernel, for instance.
> 

In the Linus case there is CONFIG_LOCALVERSION_AUTO=y by default for this.

In my tree there is 2.6.35-rc2-my-tree so it cannot be mistaken with
Linus tree.

CONFIG_LOCALVERSION_AUTO=n was: "Even if I have an SCM, please do not
inspect it."

I need that back

> When we discussed adding this indicator of revision history, we explicitly 
> noted that the `+' is a modification of the base kernel version, not the 
> entire string.
> 

My base "kernel version" is 2.6.35-rc2-my-tree. There cannot be any mistake
where this tree came from. How do I get rid of the "+"?

> As mentioned previously, you can easily suppress that from being added by 
> using "make LOCALVERSION=-foo" to create a 2.6.35-rc2-foo kernel when you 
> do not have CONFIG_LOCALVERSION_AUTO enabled.  You already found that you 
> cannot pass an empty LOCALVERSION string, so it must be something to 
> identify itself as unique from vanilla 2.6.35-rc2.
> 

As mentioned previously this is not an option I do not have git control
over how this gets compiled.

> The usecase that you've cited before is your colleagues pulling your git 
> tree and then getting this `+' appended when they really don't want it.

Yes
  
> Although localversion* files are better than (ab)using the EXTRAVERSION 
> variable in the Makefile, they won't suppress the `+' because your 
> revision history shows that you're beyond a released (tagged) kernel.

I'm now using localversion-my-tree file. It is much better thanks.

What else do I need to do so clean checkout of my tree will not have
the "+" appended. It already have the my-tree appended to it.

> The solution is to use git-tag to indicate your particular version of Linux 
> that differentiates it from vanilla 2.6.35-rc2 and pass along your version 
> information with either localversion* 

I tried that. Only with my patch it works. Hence the patch.

files or CONFIG_LOCALVERSION if you 
> package your .config as well.

Again not an option .config is derived from a distro one and is not managed
by git.

Please find me a solution? this breaks lots of stuff un-necessarily and with
no apparent gain.

Thanks
Boaz
