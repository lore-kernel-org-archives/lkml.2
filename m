Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1GJMI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:08:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59026 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab1GJMI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:08:26 -0400
X-AuditID: b753bd60-a507fba0000050a4-63-4e1996367a61
X-AuditID: b753bd60-a507fba0000050a4-63-4e1996367a61
Message-ID: <4E199633.9050200@hitachi.com>
Date: Sun, 10 Jul 2011 21:08:19 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip 4/5] [BUGFIX] perf probe: Fix the order of searching
 scopes for variables
References: <20110710100005.2550.83138.stgit@fedora15> <20110710100033.2550.78762.stgit@fedora15> <CAOJsxLHxWESTZa60hopBXUnTGn7-hJasuw_t7QAnv417TzMFBw@mail.gmail.com>
In-Reply-To: <CAOJsxLHxWESTZa60hopBXUnTGn7-hJasuw_t7QAnv417TzMFBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

(2011/07/10 20:05), Pekka Enberg wrote:
> On Sun, Jul 10, 2011 at 1:00 PM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> Fix variable searching routine to search from inner scope
>> to outer scope.
> 
> Admittedly, I don't really know this code at all. However, the
> changelog is somewhat vague. Why do we need this change? What problem
> does it fix? Why does the order in which we iterate 'scopes' matter?

Hmm, I see.

Debuginfo expresses functions and nested inlined functions as
DIE(Dwarf Information Entry) tree, and "scope" means each
level of the DIE.

Outer
^
|
  CU DIE [A](compile unit: it's an object file)
   +-global variable DIEs
   +-inline function declaration DIEs
   +-function [B] DIE
      +-local variable DIEs
      +-inline function instance [C] DIE
         +-inline local variable DIEs
         +-(nested)inline function instance [D] DIE
            +...
|
v
Inner

Imagine that if we are at [C],

nscopes = dwarf_getscopes_die([C], &scopes)

this returns scopes[] DIEs containing [C] DIE, and nscopes = 3
On that array, scopes[0] is [C], scopes[1] is [B], and scopes[2]
is [A].

And, the below loop

 while (nscopes-- > 1)
	die_find_variable_at(&scopes[nscopes], ...

starts to find variables from the outermost scope [A] and
find a global variable first.　This changes searching order
from inner scope ([B]) to outer ([A]) to search global vars
last.


Thank you!


> 
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> ---
>>
>>  tools/perf/util/probe-finder.c |   14 +++++++-------
>>  1 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
>> index 222ba66..cf7d48d 100644
>> --- a/tools/perf/util/probe-finder.c
>> +++ b/tools/perf/util/probe-finder.c
>> @@ -1135,7 +1135,7 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
>>  {
>>        Dwarf_Die vr_die, *scopes;
>>        char buf[32], *ptr;
>> -       int ret, nscopes;
>> +       int ret, nscopes, i;
>>
>>        if (!is_c_varname(pf->pvar->var)) {
>>                /* Copy raw parameters */
>> @@ -1179,11 +1179,11 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
>>                /* Search upper class */
>>                nscopes = dwarf_getscopes_die(sp_die, &scopes);
>>                ret = -ENOENT;
>> -               while (nscopes-- > 1) {
>> +               for (i = 1; i < nscopes; i++) { /* scopes[0] is sp_die */
>>                        pr_debug("Searching variables in %s\n",
>> -                                dwarf_diename(&scopes[nscopes]));
>> +                                dwarf_diename(&scopes[i]));
>>                        /* We should check this scope, so give dummy address */
>> -                       if (die_find_variable_at(&scopes[nscopes],
>> +                       if (die_find_variable_at(&scopes[i],
>>                                                 pf->pvar->var, 0,
>>                                                 &vr_die)) {
>>                                ret = convert_variable(&vr_die, pf);
>> @@ -1693,7 +1693,7 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
>>                        container_of(pf, struct available_var_finder, pf);
>>        struct variable_list *vl;
>>        Dwarf_Die die_mem, *scopes = NULL;
>> -       int ret, nscopes;
>> +       int ret, nscopes, i;
>>
>>        /* Check number of tevs */
>>        if (af->nvls == af->max_vls) {
>> @@ -1723,8 +1723,8 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
>>        /* Don't need to search child DIE for externs. */
>>        af->child = false;
>>        nscopes = dwarf_getscopes_die(sp_die, &scopes);
>> -       while (nscopes-- > 1)
>> -               die_find_child(&scopes[nscopes], collect_variables_cb,
>> +       for (i = 1; i < nscopes; i++)   /* scopes[0] is sp_die */
>> +               die_find_child(&scopes[i], collect_variables_cb,
>>                               (void *)af, &die_mem);
>>        if (scopes)
>>                free(scopes);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
