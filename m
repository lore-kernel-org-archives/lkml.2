Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2AaX5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 18:57:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46745 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2AaX5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 18:57:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Feb 2012 08:55:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] speed up /proc/pid/stat, statm
Message-Id: <20120201085546.ecbf628d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120131123612.6b60bdfc.akpm@linux-foundation.org>
References: <20120131171443.567b53ad.kamezawa.hiroyu@jp.fujitsu.com>
	<20120131123612.6b60bdfc.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 12:36:12 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 31 Jan 2012 17:14:43 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > +int seq_put_decimal_ll(struct seq_file *m, char delimiter,
> > +			long long num)
> > +{
> > +	if (num < 0) {
> > +		if (m->count + 3 >= m->size) {
> > +			m->count = m->size;
> 
> Why is m->count udpated even thought we didn't write any data? 
> seq_put_decimal_ull() does it too.
> 

seq_xxxx functions set m->count == m->size when it finds possible buffer overflow.
If m->count == m->size after ->show(), buffer will be freed and twice size buffer
will be re-allocated, and retry.

If we don't set m->count == m->size here, following seq_putc() will succeed and
we'll see corrupted outputs.


Thanks,
-Kame



> > +			return -1;
> > +		}
> > +		if (delimiter)
> > +			m->buf[m->count++] = delimiter;
> > +		num = -num;
> > +		delimiter = '-';
> > +	}
> > +	return seq_put_decimal_ull(m, delimiter, num);
> > +
> > +}
> > +EXPORT_SYMBOL(seq_put_decimal_ll);
> 

