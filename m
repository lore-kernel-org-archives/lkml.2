Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2H1TEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 15:04:11 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:48693 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2H1TEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 15:04:09 -0400
Message-ID: <503D1626.9030409@tilera.com>
Date: Tue, 28 Aug 2012 15:04:06 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Mark Salter <msalter@redhat.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Richard Kuo <rkuo@codeaurora.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Jonas Bonn <jonas@southpole.se>, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] cross-arch: don't corrupt personality flags upon
 exec()
References: <alpine.LNX.2.00.1208031143320.29827@pobox.suse.cz> <alpine.LNX.2.00.1208131518520.29827@pobox.suse.cz> <20120815154520.f9cf4e24.akpm@linux-foundation.org> <201208221927.28993.arnd@arndb.de> <503CF76C.2010105@tilera.com> <alpine.LNX.2.00.1208281135320.22447@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1208281135320.22447@pobox.suse.cz>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/2012 2:49 PM, Jiri Kosina wrote:
> On Tue, 28 Aug 2012, Chris Metcalf wrote:
>>> On tile, the PER_LINUX_32BIT is always set for 32 bit compat tasks in a
>>> 64 bit kernel, which is harmless but wrong anyway. Also this, tile never
>>> calls set_personality, which is also harmless because it just means that
>>> exec_domain switching on tile is broken, but the only non-bogus
>>> exec_domain besides the default one is an experimental support for Acorn
>>> RISC OS binaries that was last updated in 2002 for for linux-2.5.49.
>> Arnd, thanks for the drive-by code review.  Is this change the correct fix
>> for your observation?
>>
>> diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
>> index d16d006..fd31920 100644
>> --- a/arch/tile/include/asm/elf.h
>> +++ b/arch/tile/include/asm/elf.h
>> @@ -156,12 +156,12 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
>>  #undef SET_PERSONALITY
>>  #define SET_PERSONALITY(ex) \
>>  do { \
>> -       current->personality = PER_LINUX; \
>> +       set_personality(PER_LINUX);                  \
>>         current_thread_info()->status &= ~TS_COMPAT; \
>>  } while (0)
>>  #define COMPAT_SET_PERSONALITY(ex) \
>>  do { \
>> -       current->personality = PER_LINUX_32BIT; \
>> +       set_personality(PER_LINUX);                 \
>>         current_thread_info()->status |= TS_COMPAT; \
>>  } while (0)
> Actually this is also wrong. You should be rather doing
>
> 	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
>
> otherwise you clobber the upper personality bits upon exec().
>
> Something like the patch below. Either you can take it for tile, or I can 
> ask Andrew to fold it into my tree-wide fix currently waiting in -mm. Just 
> let me know.

It looks fine for tile, except that your change still uses PER_LINUX_32BIT,
which Arnd points out is wrong; my proposed patch changed it to just
PER_LINUX, though I'm not completely clear as to whether this is correct. 
The tilegx compat mode is an ILP32 mode where the compiler emits 32-bit Elf
binaries and the compat layer is used to translate to and from 32-bit
pointer and long, but nothing else.  It sounds like PER_LINUX applies
better than PER_LINUX_32BIT based on the fact that the extra 32-bit flag
isn't actually used in any architecture-independent code (nor in tile code,
which just checks whether something is a compat task per se, rather than
looking at the personality bits).

Since you have a treewide fix going anyway, I'm happy for you to push this
to Andrew.  If it's OK with the one suggested change, you can add my

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

