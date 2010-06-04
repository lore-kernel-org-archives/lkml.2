Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0FDQhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:37:06 -0400
Received: from csmtp1.one.com ([195.47.247.21]:32811 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab0FDQhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:37:02 -0400
Message-ID: <4C092BA7.507@bitmath.org>
Date: Fri, 04 Jun 2010 18:36:55 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
 buffer mechanism
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se> <1275552062-8153-2-git-send-email-rydberg@euromail.se> <20100604065658.GE21239@core.coreip.homeip.net>
In-Reply-To: <20100604065658.GE21239@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#define buflock_write(bw, buf, size, item)				\
>> +	do {								\
>> +		bw.next_head = (bw.head + 1) & ((size) - 1);		\
>> +		smp_wmb();						\
> 
> Why do we need the write barrier here?

I believe my first answer to this question was foggy indeed, so allow me to go
again, with a time line:

Scenario 1, correct write order:

writer              store_next_head   store_buf        store_head
reader  load_head   load_buf       load_next_head

Result: head != next_head, incoherent read detected

Scenario 2, incorrect write order:

writer              store_buf         store_next_head  store_head
reader  load_head   load_buf       load_next_head

Result: head == next_head, incoherent read not detected

Based on the assumption that scenario 2 could happen if the smp_wmb() is not
present, the barrier is needed.

Henrik
