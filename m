Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0JVBZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:25:25 -0400
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:40501 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751939Ab0JVBZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:25:24 -0400
From: Bruno Randolf <br1@einfach.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average (EWMA) function
Date: Fri, 22 Oct 2010 10:25:30 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com, Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
References: <20101021192658.C8EE.A69D9226@jp.fujitsu.com> <201010220953.30148.br1@einfach.org> <20101022100316.53A3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101022100316.53A3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221025.30164.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri October 22 2010 10:11:38 KOSAKI Motohiro wrote:
> few additional reviewing comments is here.
> 
> > +struct ewma {
> > +	unsigned int internal;
> > +	unsigned int factor;
> > +	unsigned int weight;
> > +};
> 
> I think unsigned long is better because long is natual register size
> on both 32bit and 64bit arch.
> and, example, almost linux resource limit is using long or ulong. then
> uint may have overflow risk if we are using this one on 64bit arch.
> Does uint has any benefit? (note: scheduler loadavg has already used ulong)

You know more about this than me. I have no specific reason to use unsigned 
int. I'll change it to unsigned long, if that's better.

> > +struct ewma*
> > +ewma_add(struct ewma *avg, const unsigned int val)
> > +{
> > +	avg->internal = avg->internal  ?
> > +		(((avg->internal * (avg->weight - 1)) +
> > +			(val * avg->factor)) / avg->weight) :
> > +		(val * avg->factor);
> > +	return avg;
> 
> Hm, if ewma_add has this function prototype, we almost always need to
> typing "new = ewma_get(ewma_add(&ewma, val))". Is this intentional?
> if so, why?
>
> Why can't we simple do following?
> 
> unsigned long ewma_add(struct ewma *avg, const unsigned int val)
> {
> (snip)
> 	return ewma_get(avg);
> }

Hmm, I guess that depends on the way you want to use it. In my case, most of 
the times when I add a value to the average, I don't need to get the value. 
I'd call ewma_add() many more times than ewma_get(). Having the functions 
defined like this gives us the flexibility to choose and IMHO  
ewma_get(ewma_add(&ewma, val)) isn't so bad?

bruno
