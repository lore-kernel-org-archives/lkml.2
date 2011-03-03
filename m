Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab1CCQdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:33:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab1CCQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:33:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Subject: Re: [PATCH, v8 1/3] hrtimer: introduce effective timer slack
Date: Thu, 3 Mar 2011 17:32:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name> <1299161947-9903-2-git-send-email-kirill@shutemov.name>
In-Reply-To: <1299161947-9903-2-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031732.28964.arnd@arndb.de>
X-Provags-ID: V02:K0:zlkwj3X77AJ50amjuUx+dQvLt7inAVIiYFe+CQnn9SB
 H9S8Q6KEsvzVn+NPsc/oP7PPiBwP8DRqioinVKT4GingS4GxP0
 zINgh0iR0GJwaUrV5LeqdcyuYxjvPFXW6u6zl/I/38InjLnHPe
 4iHutevzzwIAF+CfOlVlK2QTfujZ/wWvasVF32eh4PZB/fxw+m
 H8FFzgTTFMQM342HJqVag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 March 2011, Kirill A. Shutsemov wrote:
> task_get_effective_timer_slack() returns timer slack value to be used
> to configure per-task timers. It can be equal or higher than task's
> timer slack value.
> 
> For now task_get_effective_timer_slack() returns timer_slack_ns of the
> task. Timer slack cgroup controller will implement a bit more
> sophisticated logic.

Some time ago, there was a discussion about a method for automatically
determining timer slack values, and I think nobody ever implemented it.

The idea was to penalize tasks that have timers expiring a lot, typically
a sign of programs that were not written with power consumption in mind.

I think that could be nicely combined with your patch. Instead of setting
the effective timer slack for the entire control group, you  could
set a target value that is applied only to tasks that have their timers
expire frequently. When a timer expires for a task, you increase the
effective slack up to the maximum, and when you set up a timer, you
decrease it again. The amount by which the effective slack gets changed
can depend on how long ago the last timer expired.

Does this make sense to you?

	Arnd
