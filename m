Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2KGKCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:02:16 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:65126 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2KGKCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:02:14 -0500
MIME-Version: 1.0
In-Reply-To: <87fw4looar.fsf@sejong.aot.lge.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
	<20121106205220.GF13629@infradead.org>
	<87fw4looar.fsf@sejong.aot.lge.com>
Date: Wed, 7 Nov 2012 11:02:12 +0100
Message-ID: <CABPqkBQFhjreGVUGK6CS9YAYVJv_2ic+WQsR5Y1j6j-GKphiGw@mail.gmail.com>
Subject: Re: [PATCH v2 00/16] perf: add memory access sampling support
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 8:38 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Arnaldo,
>
> On Tue, 6 Nov 2012 17:52:21 -0300, Arnaldo Carvalho de Melo wrote:
>> Em Mon, Nov 05, 2012 at 02:50:47PM +0100, Stephane Eranian escreveu:
>> [root@sandy acme]# perf mem -t load rep --stdio --sort=symbol,symbol_daddr,cost
>> # Samples: 30  of event 'cpu/mem-loads/pp'
>> # Total cost : 640
>> # Sort order : symbol,symbol_daddr,cost
>> #
>> # Overhead      Samples                  Symbol             Data Symbol     Cost
>> # ........  ...........  ......................  ......................  .......
>> #
>>     55.00%            1  [k] lookup_fast         [k] 0xffff8803b7521bd4      352
>>      5.47%            1  [k] cache_alloc_refill  [k] 0xffff880407705024       35
>>      3.44%            1  [k] cache_alloc_refill  [k] 0xffff88041d8527d8       22
>>      3.28%            1  [k] run_timer_softirq   [k] 0xffff88041e2c3e90       21
>>      2.50%            1  [k] __list_add          [k] 0xffff8803b7521d68       16
>>      2.19%            1  [.] __strcoll_l         [.] 0x00007fffa8d44080       14
>>      1.88%            1  [.] __strcoll_l         [.] 0x00007fffa8d44104       12
>>
>> If we go to the annotation browser to see where is that lookup_fast hitting we get:
>>
>> 100.00 │       mov    -0x34(%rbp),%eax
>>
>> How to map 0xffff8803b7521bd4 to a stack variable, struct members and all?
>>

Yes, you need dwarf to achieve this. But I think we should first fix the problem
with global variables at the user and kernel levels and there all you
need is the
data symbol table (which we load because of the -d option) and correct
base+offset
calculations. For now, I am getting perf-xxxx.map for global variables.

For instance, I use the following simple test program with:
$ perf mem rec mcol 10000

I expect to see symbol aa+offset in the data symbol column and mcol in the
data object column. But instance, I get raw hex and perf-xxxx.map.

I think that's what we need to fix first.

/* mcol.c */
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

typedef struct {
        long real;
        long img;
} elem_t;

#define NB      100000ULL
static elem_t aa[NB * 2];

uint64_t
mat_column(elem_t *m, size_t nr, size_t nc, elem_t *n)
{
        uint64_t real = 0 , img = 0;
        elem_t *p;
        size_t i, j;

        /* scan by columns */
        for(i=0; i < nc; i++) {
                for(j=0; j < nr; j++) {
                        real += (m+i+nc*j)->real;
                        img += (m+i+nc*j)->img;
                }
        }
        return (real+img) > 0 ? 0 : 1;
}

int main(int argc, char **argv)
{
        size_t rows, cols;
        unsigned long long nloop, nl;
        elem_t number;

        number.real = 1;
        number.img = 5;

        nloop = nl = argc > 1 ? strtoul(argv[1], NULL, 0) : 10000;
        rows = NB;
        cols = 2;
        printf("mat[%p:%p] size=%zuMiB\n", aa, &aa[-1+NB*2], sizeof(aa) >> 20);
        while(nl--) {
                number.img++;
                number.real += mat_column(aa, rows, cols, &number);
        }
        return 0;
}
