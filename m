Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2BWQcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:32:43 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59203 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162Ab2BWQcm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:32:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.182.89.65 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223162850.GC25177@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	<20120223162850.GC25177@infradead.org>
Date: Thu, 23 Feb 2012 18:32:41 +0200
X-Google-Sender-Auth: glj2nHbbe5e_F1T6wVpA-Jqu02U
Message-ID: <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
From: Pekka Enberg <penberg@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 6:28 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Thu, Feb 23, 2012 at 06:18:42PM +0200, Pekka Enberg escreveu:
>> This patch adds a simple GTK2-based browser to 'perf report' that's based on
>> the TTY-based browser in builtin-report.c.
>>
>> Please not that you need to use
>>
>>   make WERROR=0
>>
>> to build perf on Fedora 15 (and possibly other distributions) because GTK
>> headers do not compile cleanly:
>>
>>       CC util/gtk/browser.o
>>   In file included from /usr/include/gtk-2.0/gtk/gtk.h:234:0,
>>                    from util/gtk/browser.c:7:
>>   /usr/include/gtk-2.0/gtk/gtkitemfactory.h:47:1: warning: function declaration isn’t a prototype [-Wstrict-prototypes]
>>
>> To launch "perf report" using the new GTK interface just type:
>>
>>   ./perf report --gtk
>>
>> The interface is somewhat limited in features at the moment:
>>
>>   - No callgraph support
>>
>>   - No KVM guest profiling support
>>
>>   - No color coding for percentages
>>
>>   - No sorting from the UI
>>
>>   - ..and many, many more!
>>
>> That said, I think this patch a reasonable start to build future features on.
>
> <SNIP>
>
>> +     for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
>> +             struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
>> +             GtkTreeIter iter;
>> +             double percent;
>> +             char s[512];
>> +
>> +             if (h->filtered)
>> +                     continue;
>> +
>> +             gtk_list_store_append(store, &iter);
>> +
>> +             col_idx = 0;
>> +
>> +             percent = (h->period * 100.0) / total_period;
>> +
>> +             snprintf(s, ARRAY_SIZE(s), "%.2f", percent);
>> +
>> +             gtk_list_store_set(store, &iter, col_idx++, s, -1);
>> +
>> +             list_for_each_entry(se, &hist_entry__sort_list, list) {
>> +                     if (se->elide)
>> +                             continue;
>> +
>> +                     se->se_snprintf(h, s, ARRAY_SIZE(s),
>> +                                     hists__col_len(hists, se->se_width_idx));
>> +
>> +                     gtk_list_store_set(store, &iter, col_idx++, s, -1);
>> +             }
>> +     }
>
> This is what I avoided by writing a tree widget for the TUI, I really
> didn't want to traverse _all_ the hists just to show the ones that
> appear in the screen.
>
> Isn't there a way to ask GTK to ask a callback to provide a
> representation for the Nth hist entry, i.e. just the ones it _needs_ to
> render the screen?

Dunno, probably. Does that matter, though? It's pretty damn fast as-is.

                                Pekka
