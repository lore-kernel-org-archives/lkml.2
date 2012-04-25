Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab2DYD7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:59:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48320 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871Ab2DYD7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:59:51 -0400
Message-ID: <4F9776B4.60001@ti.com>
Date: Tue, 24 Apr 2012 20:59:48 -0700
From: Russ Dill <Russ.Dill@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ktest.pl: Fix combined usage of BISECT_REVERSE and
 BISECT_SKIP
References: <1335222539-31546-1-git-send-email-Russ.Dill@ti.com>  <1335222909-14191-1-git-send-email-Russ.Dill@ti.com> <1335228915.28106.129.camel@gandalf.stny.rr.com>
In-Reply-To: <1335228915.28106.129.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:55 PM, Steven Rostedt wrote:
> On Mon, 2012-04-23 at 16:15 -0700, Russ Dill wrote:
>> When BISECT_REVERSE and BISECT_SKIP are used together with boot or test testing,
>> build failures are treated as boot or test failures and 'git bisect bad' is executed instead
>> of 'git bisect skip'. This is because the $ret value of -1 is treated as a build failure, but
>> the $reverse_bisect logic does not properly handle this.
>>
>> Simple fix, don't invert $ret if it is -1.
>>
>> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
>> ---
>>  tools/testing/ktest/ktest.pl |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
>> index 95d6a6f..5221b00 100755
>> --- a/tools/testing/ktest/ktest.pl
>> +++ b/tools/testing/ktest/ktest.pl
>> @@ -2192,7 +2192,7 @@ sub run_bisect {
>>      }
>>  
>>      # Are we looking for where it worked, not failed?
>> -    if ($reverse_bisect) {
>> +    if ($reverse_bisect && $ret != -1) {
> Thanks! But can you resend with the following change:
>
> 	... && $ret >= 0) {
>
> Just incase we have $ret be another negative number for something else.

BTW, I can across an additional problem that I'm not sure how to solve.
I'm using PRE_BUILD and POST_BUILD to apply a patch during a bisect. As
soon as the bisect hits a tree where the patch applies, the module
tar-up fails. The kernel version (and module path) has a '-dirty' but
ktest.pl is calling its get_version after POST_BUILD when the tree is clean.

