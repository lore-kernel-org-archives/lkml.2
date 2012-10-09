Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab2JIR0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:26:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47932 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2JIR0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:26:03 -0400
Date: Tue, 9 Oct 2012 18:25:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Howells <dhowells@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] Disintegrate UAPI for arm64 [ver #2]
Message-ID: <20121009172559.GB13922@arm.com>
References: <21110.1349774113@warthog.procyon.org.uk>
MIME-Version: 1.0
In-Reply-To: <21110.1349774113@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Oct 2012 17:26:00.0240 (UTC) FILETIME=[267DA300:01CDA643]
X-MC-Unique: 112100918260003401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:15:13AM +0100, David Howells wrote:
> David Howells (1):
>       UAPI: (Scripted) Disintegrate arch/arm64/include/asm

It still fails on arm64. The reason is that I had a __SYSCALL_COMPAT
guard to provide either the 32-bit syscalls or the 64-bit (generic) ones
via asm/unistd.h. With this change:

> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 8f03dee..3d43b19 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -13,13 +13,7 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> -
> -#ifndef __SYSCALL_COMPAT
> -#include <asm-generic/unistd.h>
> -#endif
> -
> -#ifdef __KERNEL__
>  #ifdef CONFIG_COMPAT
>  #include <asm/unistd32.h>
>  #endif
> -#endif
> +#include <uapi/asm/unistd.h>

the guard disappears and I get conflicting entries between unistd32.h
and unistd.h.

The solution is to either keep the __SYSCALL_COMPAT guard in place or
rename all the __NR_* macros in unistd32.h to __NR_compat_* and include
unistd32.h explicitly where needed (kernel-only header anyway). Since
the arm64 kernel would not export 32-bit headers, I would go with the
second solution (tried it already). But you need to re-generate the
arm64 headers again.

BTW, I see the script generated some pretty much empty
uapi/asm/unistd.h. Is it possible to using something like Kbuild and
just add "generic-y += ..." to just point it to the
include/uapi/asm-generic header?

-- 
Catalin

