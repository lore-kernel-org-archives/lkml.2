Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1JWL6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:58:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45328 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1JWL6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:58:08 -0400
Date: Sun, 23 Oct 2011 12:57:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 11/16] ARM: LPAE: Add fault handling support
Message-ID: <20111023115756.GB17912@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-12-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-12-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:34PM +0100, Catalin Marinas wrote:
> diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
> index be7c638..f0bf61a 100644
> --- a/arch/arm/mm/alignment.c
> +++ b/arch/arm/mm/alignment.c
> @@ -909,6 +909,12 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_ARM_LPAE
> +#define ALIGNMENT_FAULT		33
> +#else
> +#define ALIGNMENT_FAULT		1
> +#endif

Probably makes sense to move this into a header, along with the other
fault codes, other FSR bits and fsr_fs().

> +
>  /*
>   * This needs to be done after sysctl_init, otherwise sys/ will be
>   * overwritten.  Actually, this shouldn't be in sys/ at all since
> @@ -942,7 +948,7 @@ static int __init alignment_init(void)
>  		ai_usermode = UM_FIXUP;
>  	}
>  
> -	hook_fault_code(1, do_alignment, SIGBUS, BUS_ADRALN,
> +	hook_fault_code(ALIGNMENT_FAULT, do_alignment, SIGBUS, BUS_ADRALN,
>  			"alignment exception");
>  
>  	/*
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 3b5ea68..91d1768 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -33,10 +33,15 @@
>  #define FSR_WRITE		(1 << 11)
>  #define FSR_FS4			(1 << 10)
>  #define FSR_FS3_0		(15)
> +#define FSR_FS5_0		(0x3f)
>  
>  static inline int fsr_fs(unsigned int fsr)
>  {
> +#ifdef CONFIG_ARM_LPAE
> +	return fsr & FSR_FS5_0;
> +#else
>  	return (fsr & FSR_FS3_0) | (fsr & FSR_FS4) >> 6;
> +#endif
>  }
>  
>  #ifdef CONFIG_MMU
> @@ -122,8 +127,10 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
>  
>  		pte = pte_offset_map(pmd, addr);
>  		printk(", *pte=%08llx", (long long)pte_val(*pte));
> +#ifndef CONFIG_ARM_LPAE
>  		printk(", *ppte=%08llx",
>  		       (long long)pte_val(pte[PTE_HWTABLE_PTRS]));
> +#endif
>  		pte_unmap(pte);
>  	} while(0);
>  
> @@ -440,6 +447,12 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
>  	pmd = pmd_offset(pud, addr);
>  	pmd_k = pmd_offset(pud_k, addr);
>  
> +#ifdef CONFIG_ARM_LPAE
> +	/*
> +	 * Only one hardware entry per PMD with LPAE.
> +	 */
> +	index = 0;
> +#else
>  	/*
>  	 * On ARM one Linux PGD entry contains two hardware entries (see page
>  	 * tables layout in pgtable.h). We normally guarantee that we always
> @@ -449,6 +462,7 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
>  	 * for the first of pair.
>  	 */
>  	index = (addr >> SECTION_SHIFT) & 1;
> +#endif
>  	if (pmd_none(pmd_k[index]))
>  		goto bad_area;
>  
> @@ -494,6 +508,72 @@ static struct fsr_info {
>  	int	code;
>  	const char *name;
>  } fsr_info[] = {
> +#ifdef CONFIG_ARM_LPAE
> +	{ do_bad,		SIGBUS,  0,		"unknown 0"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 1"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 2"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 3"			},
> +	{ do_bad,		SIGBUS,  0,		"reserved translation fault"	},
> +	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 1 translation fault"	},
> +	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 2 translation fault"	},
> +	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"level 3 translation fault"	},
> +	{ do_bad,		SIGBUS,  0,		"reserved access flag fault"	},
> +	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 1 access flag fault"	},
> +	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 2 access flag fault"	},
> +	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 access flag fault"	},
> +	{ do_bad,		SIGBUS,  0,		"reserved permission fault"	},
> +	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
> +	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
> +	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
> +	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
> +	{ do_bad,		SIGBUS,  0,		"asynchronous external abort"	},
> +	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
> +	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> +	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> +	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> +	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> +	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
> +	{ do_bad,		SIGBUS,  0,		"asynchronous parity error"	},
> +	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
> +	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
> +	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
> +	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
> +	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
> +	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
> +	{ do_bad,		SIGBUS,  BUS_ADRALN,	"alignment fault"		},
> +	{ do_bad,		SIGBUS,  0,		"debug event"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 35"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 36"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 37"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 38"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 39"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 40"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 41"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 42"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 43"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 44"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 45"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 46"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 47"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 48"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 49"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 50"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 51"			},
> +	{ do_bad,		SIGBUS,  0,		"implementation fault (lockdown abort)" },
> +	{ do_bad,		SIGBUS,  0,		"unknown 53"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 54"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 55"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 56"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 57"			},
> +	{ do_bad,		SIGBUS,  0,		"implementation fault (coprocessor abort)" },
> +	{ do_bad,		SIGBUS,  0,		"unknown 59"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 60"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 61"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 62"			},
> +	{ do_bad,		SIGBUS,  0,		"unknown 63"			},
> +#else	/* !CONFIG_ARM_LPAE */
>  	/*
>  	 * The following are the standard ARMv3 and ARMv4 aborts.  ARMv5
>  	 * defines these to be "precise" aborts.
> @@ -535,6 +615,7 @@ static struct fsr_info {
>  	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
>  	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
>  	{ do_bad,		SIGBUS,  0,		"unknown 31"			   }
> +#endif	/* CONFIG_ARM_LPAE */

Can't we do better than this?

>  };
>  
>  void __init
> @@ -573,6 +654,9 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  }
>  
>  
> +#ifdef CONFIG_ARM_LPAE
> +#define ifsr_info	fsr_info
> +#else	/* !CONFIG_ARM_LPAE */
>  static struct fsr_info ifsr_info[] = {
>  	{ do_bad,		SIGBUS,  0,		"unknown 0"			   },
>  	{ do_bad,		SIGBUS,  0,		"unknown 1"			   },
> @@ -607,6 +691,7 @@ static struct fsr_info ifsr_info[] = {
>  	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
>  	{ do_bad,		SIGBUS,  0,		"unknown 31"			   },
>  };
> +#endif	/* CONFIG_ARM_LPAE */
>  
>  void __init
>  hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *),
> @@ -642,6 +727,7 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
>  
>  static int __init exceptions_init(void)
>  {
> +#ifndef CONFIG_ARM_LPAE
>  	if (cpu_architecture() >= CPU_ARCH_ARMv6) {
>  		hook_fault_code(4, do_translation_fault, SIGSEGV, SEGV_MAPERR,
>  				"I-cache maintenance fault");
> @@ -657,6 +743,7 @@ static int __init exceptions_init(void)
>  		hook_fault_code(6, do_bad, SIGSEGV, SEGV_MAPERR,
>  				"section access flag fault");
>  	}
> +#endif
>  
>  	return 0;
>  }

Do we even need exceptions_init() at all for LPAE?  If not, can't we
avoid the whole of this including the useless init call.
