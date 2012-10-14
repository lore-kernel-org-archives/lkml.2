Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2JNK60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:58:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60563 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab2JNK6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:58:25 -0400
Date: Sun, 14 Oct 2012 12:58:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iant@google.com" <iant@google.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Message-ID: <20121014105821.GB2165@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Ma, Ling" <ling.ma@intel.com>,
	Konrad Rzeszutek Wilk <konrad@kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iant@google.com" <iant@google.com>,
	George Spelvin <linux@horizon.com>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
 <20121011143527.GA2408@localhost.localdomain>
 <B2310DA9850C8743AA7AA0055500E90F0FD709F9@SHSMSX102.ccr.corp.intel.com>
 <20121012061813.GC9881@liondog.tnic>
 <B2310DA9850C8743AA7AA0055500E90F0FD70AC5@SHSMSX102.ccr.corp.intel.com>
 <20121012180411.GA26245@liondog.tnic>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121012180411.GA26245@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 12, 2012 at 08:04:11PM +0200, Borislav Petkov wrote:
> Right, so benchmark shows around 20% speedup on Bulldozer but this is
> a microbenchmark and before pursue this further, we need to verify
> whether this brings any palpable speedup with a real benchmark, I
> don't know, kernbench, netbench, whatever. Even something as boring as
> kernel build. And probably check for perf regressions on the rest of
> the uarches.

Ok, so to summarize, on AMD we're using REP MOVSQ which is even
faster than the unrolled version. I've added the REP MOVSQ version
to the µbenchmark. It nicely validates that we're correctly setting
X86_FEATURE_REP_GOOD on everything >= F10h and some K8s.

So, to answer Konrad's question: those patches don't concern AMD
machines.

Thanks.

-- 
Regards/Gruss,
    Boris.

--h31gzZEtNLTqOjlF
Content-Type: text/x-csrc; charset=utf-8
Content-Disposition: attachment; filename="copy-page.c"

#include<stdio.h>
#include <stdlib.h>


typedef unsigned long long int hp_timing_t;
#define  MAXSAMPLESTPT        1000
#define  MAXCOPYSIZE          (1024 * 1024)
#define  ORIG  0
#define  NEW   1
static char* buf1 = NULL;
static char* buf2 = NULL;
static int repeat_one_test = 32;

hp_timing_t _dl_hp_timing_overhead;
# define HP_TIMING_NOW(Var) \
  ({ unsigned long long _hi, _lo; \
     asm volatile ("rdtsc" : "=a" (_lo), "=d" (_hi)); \
     (Var) = _hi << 32 | _lo; })

#define HP_TIMING_DIFF(Diff, Start, End)	(Diff) = ((End) - (Start))
#define HP_TIMING_TOTAL(total_time, start, end)	\
  do									\
    {									\
      hp_timing_t tmptime;						\
      HP_TIMING_DIFF (tmptime, start + _dl_hp_timing_overhead, end);	\
	total_time += tmptime;						\
    }									\
  while (0)

#define HP_TIMING_BEST(best_time, start, end)	\
  do									\
    {									\
      hp_timing_t tmptime;						\
      HP_TIMING_DIFF (tmptime, start + _dl_hp_timing_overhead, end);	\
      if (best_time > tmptime)						\
	best_time = tmptime;						\
    }									\
  while (0)


void copy_page_org(char *dst, char *src, int len);
void copy_page_new(char *dst, char *src, int len);
void copy_page_rep_movsq(char *dst, char *src, int len);
void memcpy_c(char *dst, char *src, int len);
void (*do_memcpy)(char *dst, char *src, int len);

static void
do_one_test ( char *dst, char *src,
	     size_t len)
{
      hp_timing_t start __attribute ((unused));
      hp_timing_t stop __attribute ((unused));
      hp_timing_t best_time = ~ (hp_timing_t) 0;
      size_t i;

      for (i = 0; i < repeat_one_test; ++i)
	{
	  HP_TIMING_NOW (start);
	  do_memcpy ( dst, src, len);
	  HP_TIMING_NOW (stop);
	  HP_TIMING_BEST (best_time, start, stop);
	}

      printf ("\t\t%zd", (size_t) best_time);
}

static void
do_test (size_t align1, size_t align2, size_t len)
{
  char *s1, *s2;

  s1 = (char *) (buf1 + align1);
  s2 = (char *) (buf2 + align2);


   printf ("TPT: Len %4zd, alignment %2zd/%2zd:", len, align1, align2);
   do_memcpy = copy_page_org;
   do_one_test (s2, s1, len);
   do_memcpy = copy_page_new;
   do_one_test (s2+ (1 << 16), s1 + (1 << 16), len);
   do_memcpy = copy_page_rep_movsq;
   do_one_test(s2, s1, len);
    putchar ('\n');
}

static void test_init(void)
{
  int i;
  buf1 = valloc(MAXCOPYSIZE);
  buf2 = valloc(MAXCOPYSIZE);

  for (i = 0; i < MAXCOPYSIZE ; i = i + 64) {
        buf1[i] = buf2[i] = i & 0xff;
  }

}

void copy_page_new(char *dst, char *src, int len)
{
	__asm__("mov	$(4096/64)-5, %ecx");
__asm__("1:");
	__asm__("prefetcht0 5*64(%rsi)");
	__asm__("decb	%cl");

	__asm__("movq	0x8*0(%rsi), %r10");
	__asm__("movq	0x8*1(%rsi), %rax");
	__asm__("movq	0x8*2(%rsi), %r8");
	__asm__("movq	0x8*3(%rsi), %r9");
	__asm__("movq	%r10, 0x8*0(%rdi)");
	__asm__("movq	%rax, 0x8*1(%rdi)");
	__asm__("movq	%r8, 0x8*2(%rdi)");
	__asm__("movq	%r9, 0x8*3(%rdi)");

	__asm__("movq	0x8*4(%rsi), %r10");
	__asm__("movq	0x8*5(%rsi), %rax");
	__asm__("movq	0x8*6(%rsi), %r8");
	__asm__("movq	0x8*7(%rsi), %r9");
	__asm__("leaq	64(%rsi), %rsi");
	__asm__("movq	%r10, 0x8*4(%rdi)");
	__asm__("movq	%rax, 0x8*5(%rdi)");
	__asm__("movq	%r8, 0x8*6(%rdi)");
	__asm__("movq	%r9, 0x8*7(%rdi)");
	__asm__("leaq	64(%rdi), %rdi");
	__asm__("jnz     1b");
	__asm__("mov	$5, %dl");
__asm__("2:");
	__asm__("decb	%dl");
	__asm__("movq	0x8*0(%rsi), %r10");
	__asm__("movq	0x8*1(%rsi), %rax");
	__asm__("movq	0x8*2(%rsi), %r8");
	__asm__("movq	0x8*3(%rsi), %r9");
	__asm__("movq	%r10, 0x8*0(%rdi)");
	__asm__("movq	%rax, 0x8*1(%rdi)");
	__asm__("movq	%r8, 0x8*2(%rdi)");
	__asm__("movq	%r9, 0x8*3(%rdi)");

	__asm__("movq	0x8*4(%rsi), %r10");
	__asm__("movq	0x8*5(%rsi), %rax");
	__asm__("movq	0x8*6(%rsi), %r8");
	__asm__("movq	0x8*7(%rsi), %r9");
	__asm__("leaq	64(%rsi), %rsi");
	__asm__("movq	%r10, 0x8*4(%rdi)");
	__asm__("movq	%rax, 0x8*5(%rdi)");
	__asm__("movq	%r8, 0x8*6(%rdi)");
	__asm__("movq	%r9, 0x8*7(%rdi)");
	__asm__("leaq	64(%rdi), %rdi");

	__asm__("jnz	2b");

}


void copy_page_org(char *dst, char *src, int len)
{

	__asm__("subq	$2*8,%rsp");
	__asm__("movq	%rbx,(%rsp)");
	__asm__("movq	%r12,1*8(%rsp)");
	__asm__("movl	$(4096/64)-5,%ecx");
	__asm__(".p2align 4");
__asm__("1:");
	__asm__("dec     %rcx");

	__asm__("movq        (%rsi), %rax");
	__asm__("movq      8 (%rsi), %rbx");
	__asm__("movq     16 (%rsi), %rdx");
	__asm__("movq     24 (%rsi), %r8");
	__asm__("movq     32 (%rsi), %r9");
	__asm__("movq     40 (%rsi), %r10");
	__asm__("movq     48 (%rsi), %r11");
	__asm__("movq     56 (%rsi), %r12");

	__asm__("prefetcht0 5*64(%rsi)");

	__asm__("movq     %rax,    (%rdi)");
	__asm__("movq     %rbx,  8 (%rdi)");
	__asm__("movq     %rdx, 16 (%rdi)");
	__asm__("movq     %r8,  24 (%rdi)");
	__asm__("movq     %r9,  32 (%rdi)");
	__asm__("movq     %r10, 40 (%rdi)");
	__asm__("movq     %r11, 48 (%rdi)");
	__asm__("movq     %r12, 56 (%rdi)");

	__asm__("leaq    64 (%rsi), %rsi");
	__asm__("leaq    64 (%rdi), %rdi");
	__asm__("jnz     1b");

	__asm__("movl	$5,%ecx");
	__asm__(".p2align 4");
__asm__("2:");
	__asm__("decl   %ecx");

	__asm__("movq        (%rsi), %rax");
	__asm__("movq      8 (%rsi), %rbx");
	__asm__("movq     16 (%rsi), %rdx");
	__asm__("movq     24 (%rsi), %r8");
	__asm__("movq     32 (%rsi), %r9");
	__asm__("movq     40 (%rsi), %r10");
	__asm__("movq     48 (%rsi), %r11");
	__asm__("movq     56 (%rsi), %r12");

	__asm__("movq     %rax,    (%rdi)");
	__asm__("movq     %rbx,  8 (%rdi)");
	__asm__("movq     %rdx, 16 (%rdi)");
	__asm__("movq     %r8,  24 (%rdi)");
	__asm__("movq     %r9,  32 (%rdi)");
	__asm__("movq     %r10, 40 (%rdi)");
	__asm__("movq     %r11, 48 (%rdi)");
	__asm__("movq     %r12, 56 (%rdi)");

	__asm__("leaq	64(%rdi),%rdi");
	__asm__("leaq	64(%rsi),%rsi");

	__asm__("jnz	2b");

	__asm__("movq	(%rsp),%rbx");
	__asm__("movq	1*8(%rsp),%r12");
	__asm__("addq	$2*8,%rsp");
}

void copy_page_rep_movsq(char *dst, char *src, int len)
{
	__asm__("movl $4096/8,%ecx");
	__asm__("rep movsq");
}

int main(void)
{
	test_init();
	printf ("%35s", "");
	printf ("\t%s\t%s\t%s\n", "copy_page_org", "copy_page_new", "REP MOVSQ");

	do_test(0, 0, 4096);
	do_test(0, 0, 4096);
	do_test(0, 0, 4096);
	do_test(0, 0, 4096);
	do_test(0, 0, 4096);
	return 0;
}

--h31gzZEtNLTqOjlF--
