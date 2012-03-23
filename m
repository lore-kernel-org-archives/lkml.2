Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab2CWMwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:52:50 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42549 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CWMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:52:49 -0400
X-AuditID: b753bd60-a1c87ba000000655-d5-4f6c721e4ccf
X-AuditID: b753bd60-a1c87ba000000655-d5-4f6c721e4ccf
Message-ID: <4F6C721B.9060807@hitachi.com>
Date: Fri, 23 Mar 2012 21:52:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@infradead.org,
        ananth@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] perf - probe finder fails to resolve function name to
 address
References: <4F6AF410.1010400@linux.vnet.ibm.com> <4F6AFD92.4030603@linux.vnet.ibm.com>
In-Reply-To: <4F6AFD92.4030603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2012/03/22 19:23), Prashanth Nageshappa wrote:
> probe finder fails to resolve valid function names into addresses for
> functions which have more than one die entries in DWARF info.
> 
> It is valid for DWARF info to contain more than 1 entries for a given
> function name, where one entry corresponds to definition which has code
> address/range attributes and remaining entries (which are only
> declarations) does not have code address/range attributes.
> (example: do_fork, sys_write, sys_wait4, sys_sync etc)

Hmm, I'd like to reproduce and see what happened on debuginfo in those cases.
Could you tell me your environment or actual dwarf dump of those entries as below?

$ readelf -wi vmlinux | grep do_fork -A 16

for example, on my fedora15, it shows;

    <3c68a3>   DW_AT_name        : (indirect string, offset: 0x201e0): do_fork_idle
    <3c68a7>   DW_AT_decl_file   : 2
    <3c68a8>   DW_AT_decl_line   : 631
    <3c68aa>   DW_AT_prototyped  : 1
    <3c68ab>   DW_AT_low_pc      : 0xffffffff817f0e25
    <3c68b3>   DW_AT_high_pc     : 0xffffffff817f0e47
    <3c68bb>   DW_AT_frame_base  : 1 byte block: 9c     (DW_OP_call_frame_cfa)
    <3c68bd>   DW_AT_sibling     : <0x3c68e2>
 <2><3c68c1>: Abbrev Number: 92 (DW_TAG_formal_parameter)
    <3c68c2>   DW_AT_name        : (indirect string, offset: 0x20a53d): work
    <3c68c6>   DW_AT_decl_file   : 2
--
    <672173>   DW_AT_name        : (indirect string, offset: 0x2d346): do_fork
    <672177>   DW_AT_decl_file   : 3
    <672178>   DW_AT_decl_line   : 1519
    <67217a>   DW_AT_prototyped  : 1
    <67217b>   DW_AT_type        : <0x65ab83>
    <67217f>   DW_AT_low_pc      : 0xffffffff8103cb40
    <672187>   DW_AT_high_pc     : 0xffffffff8103ce75
    <67218f>   DW_AT_frame_base  : 1 byte block: 9c     (DW_OP_call_frame_cfa)
    <672191>   DW_AT_sibling     : <0x6727bd>
 <2><672195>: Abbrev Number: 105 (DW_TAG_formal_parameter)
    <672196>   DW_AT_name        : (indirect string, offset: 0xc27d): clone_flags

I'd like to see what attribute was different in the case which you encountered.


> If die entries corresponding to declarations appear before definition
> entry, probe finder returns error instead of continuing to look further
> for a definition entry.
> 
> This patch ensures we reach to the die entry corresponding to the
> definition and get the function address. I have also removed the
> warning as this is a valid thing to happen.
> 
> Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
> ---
> 
>  tools/perf/util/probe-finder.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 5d73262..5e1e6f7 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -984,10 +984,7 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
>  			param->retval = find_probe_point_lazy(sp_die, pf);

At least we must consider this lazy_line case. If I understand correctly,
that can also affect find_probe_point_lazy(sp_die, pf);

If I find the different attribute, I'd like to add a checker function and
filter it out at early step in this function.

>  		else {
>  			if (dwarf_entrypc(sp_die, &pf->addr) != 0) {
> -				pr_warning("Failed to get entry address of "
> -					   "%s.\n", dwarf_diename(sp_die));
> -				param->retval = -ENOENT;
> -				return DWARF_CB_ABORT;
> +				return DWARF_CB_OK;
>  			}
>  			pf->addr += pp->offset;
>  			/* TODO: Check the address in this function */
> 

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
