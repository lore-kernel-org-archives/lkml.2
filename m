Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2AMBqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:46:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38356 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2AMBqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:46:36 -0500
MIME-Version: 1.0
In-Reply-To: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
Date: Thu, 12 Jan 2012 17:46:36 -0800
X-Google-Sender-Auth: BtCY5teWxYFepwFo9zL_FxkRbkU
Message-ID: <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
Subject: Re: x86, mce, Use user return notifier in mce
From: Tony Luck <tony.luck@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 4:36 PM, Huang Ying <ying.huang@intel.com> wrote:
> Replace the home-made TIF_MCE_NOTIFY based code in MCE with user
> return notifier.

When I looked at this before, I found that the existing user return notifier had
the meaning "call a function before THIS CPU returns to user space". Use in KVM
was to update some MSR that needed adjustment before a cpu ran another user
process.

The MCE code wanted something slightly different: "call a function before THIS
PROCESS returns to user space". So my prototype code from last year made a
whole new set of interfaces - similar in style to the user return
notifier, but with
the MCE semantics.

At first glance it looks like you are just using the user return
notifier code (perhaps
I'm mis-reading the diff?). This won't work - it's possible for a
context switch, and
then the process that hit the MCE may get moved to another cpu, when it will
be run. Meanwhile we'll execute our function in the context of some
other process.

-Tony
