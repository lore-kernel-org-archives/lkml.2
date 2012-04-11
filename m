Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab2DKDGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 23:06:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab2DKDGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 23:06:34 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=unLN5eZtZcEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=tsEaMpVCi5LZAc7MKDgA:9 a=LlAuucVxmTia-B0gBl4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334113588.23924.234.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Tue, 10 Apr 2012 23:06:28 -0400
In-Reply-To: <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:

> +/*
> + * Pure Earliest Deadline First (EDF) scheduling does not deal with the
> + * possibility of a entity lasting more than what it declared, and thus
> + * exhausting its runtime.
> + *
> + * Here we are interested in making runtime overrun possible, but we do
> + * not want a entity which is misbehaving to affect the scheduling of all
> + * other entities.
> + * Therefore, a budgeting strategy called Constant Bandwidth Server (CBS)
> + * is used, in order to confine each entity within its own bandwidth.
> + *
> + * This function deals exactly with that, and ensures that when the runtime
> + * of a entity is replenished, its deadline is also postponed. That ensures
> + * the overrunning entity can't interfere with other entity in the system and
> + * can't make them miss their deadlines. Reasons why this kind of overruns
> + * could happen are, typically, a entity voluntarily trying to overcume its

s/overcume/overcome/

-- Steve

> + * runtime, or it just underestimated it during sched_setscheduler_ex().
> + */
> +static void replenish_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +

