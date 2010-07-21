Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0GUOQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 10:16:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0GUOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 10:16:09 -0400
X-Authority-Analysis: v=1.1 cv=QegmR36pPmYK5pONHUGfVfb2Xn4zU2Kibu9Jhh5Kkp4= c=1 sm=0 a=nF0KFOgYotYA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=RYkCmDwOOEg20aDq3icA:9 a=KPXUkI9Ir-KHgU0_PRkVolIP9_4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
From: Steven Rostedt <rostedt@goodmis.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20100721222508.8704.A69D9226@jp.fujitsu.com>
References: <4C401CE3.7010004@cn.fujitsu.com>
	 <20100721222508.8704.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 21 Jul 2010 10:16:06 -0400
Message-ID: <1279721766.4818.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 22:31 +0900, KOSAKI Motohiro wrote:
> Hi Steven,

>         if (ac)
> 	        trace_ext4_mb_release_group_pa(ac, pa);
> 
> But, I don't think this is proper fix because we don't want any overhead
> if the tracepoint is disabled.
> 
> So, How do we check NULL in TP_fast_assign()?

You could do:

	TP_fast_assign(
		if (ac) {
	                __entry->dev            = ac->ac_sb->s_dev;
        	        __entry->ino            = ac->ac_inode->i_ino;
        	        __entry->pa_pstart      = pa->pa_pstart;
        	        __entry->pa_len         = pa->pa_len;
		}
        ),

But this just makes the __entry null and wastes the ring buffer.

I may be able to add a __discard_entry that may help. Then we could do
something like this:

	if (ac) {
                __entry->dev            = ac->ac_sb->s_dev;
                __entry->ino            = ac->ac_inode->i_ino;
                __entry->pa_pstart      = pa->pa_pstart;
                __entry->pa_len         = pa->pa_len;
	} else
		__discard_entry;

Does this seem reasonable?

But for now, the wasting the entry seems to be the only choice we have,
or to do as you suggested and have the "if (ac) trace_...", but I don't
like that.

-- Steve



