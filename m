Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2IFQf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:35:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44338 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757850Ab2IFQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:35:58 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18p/xITuy4p539AUBGTQ5axAy0iQIv22VjjNDZ3oZ
	SypftKoUuvVhyF
Message-ID: <5048D0E5.20103@gmx.de>
Date: Thu, 06 Sep 2012 18:35:49 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: does gcc gives a false warning in kernel/trace/trace_events_filter.c
 ?
References: <50432132.90307@gmx.de> <1346864883.27919.56.camel@gandalf.local.home>
In-Reply-To: <1346864883.27919.56.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 07:08 PM, Steven Rostedt wrote:
> On Sun, 2012-09-02 at 11:04 +0200, Toralf Förster wrote:
>> The current git tree of linux gave with gcc-4.6.3 :
>>
>> kernel/trace/trace_events_filter.c: In function ‘ftrace_function_set_filter_cb’:
>> kernel/trace/trace_events_filter.c:2074:8: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized] 
>>
>>
>> which refers to this piece of code:
>>
>>
>>   2061  static int ftrace_function_set_filter_cb(enum move_type move,
>>   2062                                           struct filter_pred *pred,
>>   2063                                           int *err, void *data)
>>   2064  {
>>   2065          /* Checking the node is valid for function trace. */
>>   2066          if ((move != MOVE_DOWN) ||
>>   2067              (pred->left != FILTER_PRED_INVALID)) {
>>   2068                  *err = ftrace_function_check_pred(pred, 0);
>>   2069          } else {
>>   2070                  *err = ftrace_function_check_pred(pred, 1);
>>   2071                  if (*err)
>>   2072                          return WALK_PRED_ABORT;
>>   2073 
>>   2074                  *err = __ftrace_function_set_filter(pred->op == OP_EQ,
>>   2075                                                      pred->regex.pattern,
>>   2076                                                      pred->regex.len,
>>   2077                                                      data);
>>   2078          }
>>   2079 
>>   2080          return (*err) ? WALK_PRED_ABORT : WALK_PRED_DEFAULT;
>>   2081  }
>>   2082  
>>
>>
>> >From a Gentoo forum user I got a hint :
>>
>> "Maybe it's some kind of a weird inlining issue? I think it's
>> referring to the ret in __ftrace_function_set_filter(), which would be
>> uninitialized if the for-loop does not run (re_cnt ≤ 0)"
>>
>> Now I'm wondering if re_cnt can become zero or if gcc is wrong here ?
>>
> 
> Strange, as ret is initialized to 'ret = -EINVAL;' in
> __ftrace_function_set_filter(). I'm thinking that gcc got confused here.
> Maybe report it to the gcc maintainers?
> 
> -- Steve
> 

I filed a bug report

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=54495
and got this answer : 

--- Comment #1 from Hans-Peter Nilsson <hp at gcc dot gnu.org> 2012-09-05 22:14:00 UTC ---
But if the call to ftrace_function_filter_re sets re_cnt to 0, then ret indeed
will be used uninitialized AFAICT.  What am I missing?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
