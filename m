Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681Ab2FDN6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:58:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33042 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab2FDN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:58:07 -0400
X-AuditID: b753bd60-90ec9ba000001453-1d-4fccbeebddcb
X-AuditID: b753bd60-90ec9ba000001453-1d-4fccbeebddcb
Message-ID: <4FCCBEE9.8030006@hitachi.com>
Date: Mon, 04 Jun 2012 22:58:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH -tip  1/9] ftrace: Add pt_regs acceptable trace
 callback
References: <20120529124833.9191.23007.stgit@localhost.localdomain>  <20120529124857.9191.5868.stgit@localhost.localdomain> <1338602877.13348.474.camel@gandalf.stny.rr.com>
In-Reply-To: <1338602877.13348.474.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/02 11:07), Steven Rostedt wrote:
> On Tue, 2012-05-29 at 21:48 +0900, Masami Hiramatsu wrote:
> 
>>  struct ftrace_ops {
>> -	ftrace_func_t			func;
>> +	union {
>> +		ftrace_func_t			func;
>> +		ftrace_regs_func_t		regs_func;
>> +	};
>>  	struct ftrace_ops		*next;
>>  	unsigned long			flags;
>>  	int __percpu			*disabled;
>> @@ -164,6 +182,7 @@ static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
>>  }
> 
> [..]
> 
>>  
>>  static struct ftrace_ops global_ops = {
>> -	.func			= ftrace_stub,
>> +	.regs_func		= ftrace_regs_stub,
>>  	.notrace_hash		= EMPTY_HASH,
>>  	.filter_hash		= EMPTY_HASH,
>> +	.flags			= FTRACE_OPS_FL_SAVE_REGS,
>>  };
>>  
>>  static DEFINE_MUTEX(ftrace_regex_lock);
>> @@ -3911,7 +3924,8 @@ void __init ftrace_init(void)
>>  #else
>>  
>>  static struct ftrace_ops global_ops = {
>> -	.func			= ftrace_stub,
>> +	.regs_func		= ftrace_regs_stub,
>> +	.flags			= FTRACE_OPS_FL_SAVE_REGS,
>>  };
>>  
> 
> Ug, this wont compile with some versions of gcc :-(
> 
> The one I stumbled on is gcc 4.5.1 (which I test builds against 4.5.1
> and 4.6.0). Then I saw this BZ:
> 
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=10676
> 
> This can't be a union :-(  Then we can not initialize it.

Hmm, how about initializing in __init function ?
Or we can make func and regs_func in different members,
instead of using a union. (in that case, we can remove
FTRACE_OPS_FL_SAVE_REGS.)
I just consider passing uninitialized argument to user
function can cause unexpected behavior...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
