Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2CSPVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab2CSPVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:21:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1121.1332169437@redhat.com>
References: <1121.1332169437@redhat.com> <20120318235114.GA30497@thor.bakeyournoodle.com> <20120318184105.GC2095@windriver.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: dhowells@redhat.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for March 18, 2012
Date: Mon, 19 Mar 2012 15:21:31 +0000
Message-ID: <9942.1332170491@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells <dhowells@redhat.com> wrote:

> Tony Breeds <tony@bakeyournoodle.com> wrote:
> 
> > > 	frv:defconfig  (arch/frv/kernel/head.S operand out of range)
> 
> What binutils are you using?  I suspect this is fixed by a patch that only
> went upstream very recently.  Are you using a 64-bit machine to do your
> compilation?

Here's a patch I got from Nick Clifton to fix 64-bit binutils to handle
representing things like 0xfffffff1 as a 32-bit negative immediate argument.
It has been applied upstream.

David
---
Index: opcodes/cgen-asm.c
===================================================================
RCS file: /cvs/src/src/opcodes/cgen-asm.c,v
retrieving revision 1.14
diff -c -3 -p -r1.14 cgen-asm.c
*** opcodes/cgen-asm.c	2 Sep 2009 07:20:29 -0000	1.14
--- opcodes/cgen-asm.c	15 Dec 2011 08:27:02 -0000
*************** cgen_parse_signed_integer (CGEN_CPU_DESC
*** 268,274 ****
       &result, &value);
    /* FIXME: Examine `result'.  */
    if (!errmsg)
!     *valuep = value;
    return errmsg;
  }
  
--- 268,291 ----
       &result, &value);
    /* FIXME: Examine `result'.  */
    if (!errmsg)
!     {
! #if 1
!       /* Handle the case where a hex value is parsed on a 64-bit host.
! 	 A value like 0xffffe000 is clearly intended to be a negative
! 	 16-bit value, but on a 64-bit host it will be parsed by gas
! 	 as 0x00000000ffffe000.
! 
! 	 The shifts below are designed not to produce compile time
! 	 warnings when compiled on a 32-bit host.  */
!       if (sizeof (value) > 4
! 	  && result == CGEN_PARSE_OPERAND_RESULT_NUMBER
! 	  && value > 0
! 	  && (value & 0x80000000)
! 	  && ((value >> 31) == 1))
! 	value |= -1 << 31;
! #endif
!       *valuep = value;
!     }
    return errmsg;
  }
  
Index: opcodes/frv-asm.c
===================================================================
RCS file: /cvs/src/src/opcodes/frv-asm.c,v
retrieving revision 1.19
diff -c -3 -p -r1.19 frv-asm.c
*** opcodes/frv-asm.c	27 Jun 2010 04:07:55 -0000	1.19
--- opcodes/frv-asm.c	15 Dec 2011 08:27:02 -0000
*************** parse_uhi16 (CGEN_CPU_DESC cd,
*** 465,475 ****
  	  if (errmsg == NULL
  	      && result_type == CGEN_PARSE_OPERAND_RESULT_NUMBER)
  	    {
! 	      /* If bfd_vma is wider than 32 bits, but we have a sign-
! 		 or zero-extension, truncate it.  */
! 	      if (value >= - ((bfd_vma)1 << 31)
! 		  || value <= ((bfd_vma)1 << 31) - (bfd_vma)1)
  		value &= (((bfd_vma)1 << 16) << 16) - 1;
  	      value >>= 16;
  	    }
  	  *valuep = value;
--- 465,475 ----
  	  if (errmsg == NULL
  	      && result_type == CGEN_PARSE_OPERAND_RESULT_NUMBER)
  	    {
! 	      /* If value is wider than 32 bits then be
! 		 careful about how we extract bits 16-31.  */
! 	      if (sizeof (value) > 4)
  		value &= (((bfd_vma)1 << 16) << 16) - 1;
+ 
  	      value >>= 16;
  	    }
  	  *valuep = value;
