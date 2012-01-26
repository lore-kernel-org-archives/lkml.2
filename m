Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2AZXCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:02:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:36285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2AZXCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:02:09 -0500
MIME-Version: 1.0
In-Reply-To: <20120126.173205.137498840079872845.davem@davemloft.net>
References: <20120126.173205.137498840079872845.davem@davemloft.net>
Date: Fri, 27 Jan 2012 01:02:08 +0200
Message-ID: <CALLzPKYnqdYfXHUzH+OTr+fv2Y3VBOjjYdSTOtn4HkPvuB7eXw@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib: Fix multiple definitions of clz_tab
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:32 AM, David Miller <davem@davemloft.net> wrote:
>
> Both sparc 32-bit's software divide assembler and MPILIB provide
> clz_tab[] with identical contents.
>
> Break it out into a seperate object file and select it when
> SPARC32 or MPILIB is set.
>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  arch/sparc/Kconfig      |    1 +
>  arch/sparc/lib/divdi3.S |   16 +---------------
>  lib/Kconfig             |    4 ++++
>  lib/Makefile            |    2 ++
>  lib/clz_tab.c           |   18 ++++++++++++++++++
>  lib/mpi/mpi-bit.c       |   19 -------------------
>  6 files changed, 26 insertions(+), 34 deletions(-)
>  create mode 100644 lib/clz_tab.c
>
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 9665799..ca5580e 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -33,6 +33,7 @@ config SPARC
>  config SPARC32
>        def_bool !64BIT
>        select GENERIC_ATOMIC64
> +       select CLZ_TAB
>
>  config SPARC64
>        def_bool 64BIT
> diff --git a/arch/sparc/lib/divdi3.S b/arch/sparc/lib/divdi3.S
> index 681b368..d74bc09 100644
> --- a/arch/sparc/lib/divdi3.S
> +++ b/arch/sparc/lib/divdi3.S
> @@ -17,23 +17,9 @@ along with GNU CC; see the file COPYING.  If not, write to
>  the Free Software Foundation, 59 Temple Place - Suite 330,
>  Boston, MA 02111-1307, USA.  */
>
> -       .data
> -       .align 8
> -       .globl  __clz_tab
> -__clz_tab:
> -       .byte   0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
> -       .byte   6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
> -       .byte   7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
> -       .byte   7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
> -       .byte   8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
> -       .byte   8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
> -       .byte   8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
> -       .byte   8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
> -       .size    __clz_tab,256
> -       .global .udiv
> -
>        .text
>        .align 4
> +       .global .udiv
>        .globl __divdi3
>  __divdi3:
>        save %sp,-104,%sp
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 169eb7c..d69d321 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -279,6 +279,9 @@ config AVERAGE
>
>          If unsure, say N.
>
> +config CLZ_TAB
> +       bool
> +
>  config CORDIC
>        tristate "CORDIC algorithm"
>        help
> @@ -287,6 +290,7 @@ config CORDIC
>
>  config MPILIB
>        tristate
> +       select CLZ_TAB
>        help
>          Multiprecision maths library from GnuPG.
>          It is used to implement RSA digital signature verification,
> diff --git a/lib/Makefile b/lib/Makefile
> index d71aae1..18515f0 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -121,6 +121,8 @@ obj-$(CONFIG_DQL) += dynamic_queue_limits.o
>  obj-$(CONFIG_MPILIB) += mpi/
>  obj-$(CONFIG_SIGNATURE) += digsig.o
>
> +obj-$(CONFIG_CLZ_TAB) += clz_tab.o
> +
>  hostprogs-y    := gen_crc32table
>  clean-files    := crc32table.h
>
> diff --git a/lib/clz_tab.c b/lib/clz_tab.c
> new file mode 100644
> index 0000000..7287b4a
> --- /dev/null
> +++ b/lib/clz_tab.c
> @@ -0,0 +1,18 @@
> +const unsigned char __clz_tab[] = {
> +       0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5,
> +           5, 5, 5, 5, 5, 5, 5, 5,
> +       6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
> +           6, 6, 6, 6, 6, 6, 6, 6,
> +       7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
> +           7, 7, 7, 7, 7, 7, 7, 7,
> +       7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
> +           7, 7, 7, 7, 7, 7, 7, 7,
> +       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> +           8, 8, 8, 8, 8, 8, 8, 8,
> +       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> +           8, 8, 8, 8, 8, 8, 8, 8,
> +       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> +           8, 8, 8, 8, 8, 8, 8, 8,
> +       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> +           8, 8, 8, 8, 8, 8, 8, 8,
> +};
> diff --git a/lib/mpi/mpi-bit.c b/lib/mpi/mpi-bit.c
> index 854c9c6..2f52662 100644
> --- a/lib/mpi/mpi-bit.c
> +++ b/lib/mpi/mpi-bit.c
> @@ -21,25 +21,6 @@
>  #include "mpi-internal.h"
>  #include "longlong.h"
>
> -const unsigned char __clz_tab[] = {
> -       0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5,
> -           5, 5, 5, 5, 5, 5, 5, 5,
> -       6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
> -           6, 6, 6, 6, 6, 6, 6, 6,
> -       7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
> -           7, 7, 7, 7, 7, 7, 7, 7,
> -       7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
> -           7, 7, 7, 7, 7, 7, 7, 7,
> -       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> -           8, 8, 8, 8, 8, 8, 8, 8,
> -       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> -           8, 8, 8, 8, 8, 8, 8, 8,
> -       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> -           8, 8, 8, 8, 8, 8, 8, 8,
> -       8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
> -           8, 8, 8, 8, 8, 8, 8, 8,
> -};
> -
>  #define A_LIMB_1 ((mpi_limb_t) 1)
>
>  /****************
> --
> 1.7.6.401.g6a319
>

Nice...
How should I deal with your patches?
I send patches via LSM list. James Morris applies them.
Should I re-send them along with my patches?

- Dmitry
