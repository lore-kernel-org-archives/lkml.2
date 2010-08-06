Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213Ab0HFKXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:23:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760902Ab0HFKXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:23:19 -0400
Message-ID: <4C5BE229.1090801@suse.cz>
Date: Fri, 06 Aug 2010 12:21:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix make oldconfig
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> <4C5B64EA.2000804@gmail.com> <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com> <20100806051354.GA24343@merkur.ravnborg.org>
In-Reply-To: <20100806051354.GA24343@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.8.2010 07:13, Sam Ravnborg wrote:
> [PATCH] kconfig: fix make oldconfig
> 
> Linus wrote:
>  This seems to make "make oldconfig" a _lot_ more verbose than it
>  used to be. In a very annoying way.
> 
>  I just did a quick git bisect. It's introduced by commit 4062f1a4c030
>  ("kconfig: use long options in conf") by Sam Ravnborg. Apparently that
>  thing is totally buggy, and doesn't just change the option names, but
>  actively breaks them.
> 
> The old behaviour (from years ago) were reintroduced by accident.
> Fix this so we are back to the version that are silent
> if there is nothing to ask about.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> 
> Sorry for this regression. Dunno how I missed it.
> I guess I only tested "silentoldconfig".
> 
> Following patch seems obviously correct but as I am on the way
> out of the door I could not do much testing.
> 
> 	Sam
> 
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 010600e..274f271 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -599,12 +599,12 @@ int main(int ac, char **av)
>  		break;
>  	case savedefconfig:
>  		break;
> -	case oldconfig:
>  	case oldaskconfig:
>  		rootEntry = &rootmenu;
>  		conf(&rootmenu);
>  		input_mode = silentoldconfig;
>  		/* fall through */
> +	case oldconfig:
>  	case listnewconfig:
>  	case oldnoconfig:
>  	case silentoldconfig:

Reviewed-by: Michal Marek <mmarek@suse.cz>

The problem is that in the previous code, input_mode could never be set
to 'ask_new' ('oldconfig' in the new code), both oldconfig and
silentoldconfig set the variable to 'ask_silent'. Therefore, the 'case
ask_new:' label had no effect here. The fix is correct, both oldconfig
and silentoldconfig jump to the same place again.

Linus, will you apply this directly or should I apply it to the kbuild
tree and send you a pull request?

Michal
