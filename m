Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0KYLEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:04:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60899 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab0KYLEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O30EjPq/XZMNSycRZxF89hmhk18lQwtrBDUajthbBzVPTNddqxD85qr256XPFuUxig
         UbWiBEtTqrSbsXgrJunfWmO4Xuw3g1xvbAbP3xEJ0CeseCDeXF/vGwgBWBQ765XT7sye
         RpHwXsXuFZTEuhorB3Qf2WeNhzomK8r40vO3g=
MIME-Version: 1.0
In-Reply-To: <20101124144540.GB15875@ghostprotocols.net>
References: <1290598502-31727-1-git-send-email-tom.leiming@gmail.com>
	<20101124144540.GB15875@ghostprotocols.net>
Date: Thu, 25 Nov 2010 19:04:48 +0800
Message-ID: <AANLkTinkvA=cVb4+ctR6w6bTsevttwp3C016Z2XEMAOC@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf:tools: avoid to create much more maps for kernel
 symbols on ARM
From: Ming Lei <tom.leiming@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Em Wed, Nov 24, 2010 at 07:35:02PM +0800, tom.leiming@gmail.com escreveu:
>> From: Ming Lei <tom.leiming@gmail.com>
>
>> On ARM, module addresss space is ahead of kernel space, so the module
>> symbols are handled before kernel symbol in dso__split_kallsyms, then
>> cause one map is created for each kernel symbol.
>
>> This patch fixes the issue by restoring to original kernel map in
>> dso__split_kallsyms() to avoid create unnecessary maps for kernel
>> symbols when starting to handle kenel symbol maps but after module
>> symbol maps are handled over.
>
> Can you try with the following patch instead?

Fine to me.

Reported-and-tested-by: Ming Lei <tom.leiming@gmail.com>

>
> - Arnaldo
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index b39f499..a7518d2 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -530,7 +530,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
>        struct machine *machine = kmaps->machine;
>        struct map *curr_map = map;
>        struct symbol *pos;
> -       int count = 0;
> +       int count = 0, moved = 0;
>        struct rb_root *root = &self->symbols[map->type];
>        struct rb_node *next = rb_first(root);
>        int kernel_range = 0;
> @@ -588,6 +588,11 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
>                        char dso_name[PATH_MAX];
>                        struct dso *dso;
>
> +                       if (count == 0) {
> +                               curr_map = map;
> +                               goto filter_symbol;
> +                       }
> +
>                        if (self->kernel == DSO_TYPE_GUEST_KERNEL)
>                                snprintf(dso_name, sizeof(dso_name),
>                                        "[guest.kernel].%d",
> @@ -613,7 +618,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
>                        map_groups__insert(kmaps, curr_map);
>                        ++kernel_range;
>                }
> -
> +filter_symbol:
>                if (filter && filter(curr_map, pos)) {
>  discard_symbol:                rb_erase(&pos->rb_node, root);
>                        symbol__delete(pos);
> @@ -621,8 +626,9 @@ discard_symbol:             rb_erase(&pos->rb_node, root);
>                        if (curr_map != map) {
>                                rb_erase(&pos->rb_node, root);
>                                symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
> -                       }
> -                       count++;
> +                               ++moved;
> +                       } else
> +                               ++count;
>                }
>        }
>
> @@ -632,7 +638,7 @@ discard_symbol:             rb_erase(&pos->rb_node, root);
>                dso__set_loaded(curr_map->dso, curr_map->type);
>        }
>
> -       return count;
> +       return count + moved;
>  }
>
>  int dso__load_kallsyms(struct dso *self, const char *filename,
>

thanks,
-- 
Lei Ming
