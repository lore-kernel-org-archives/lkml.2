Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab2HWVc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:32:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56430 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2HWVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:32:54 -0400
Message-ID: <5036A182.7030707@gmail.com>
Date: Thu, 23 Aug 2012 15:32:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>,
        Bernhard Rosenkraenzer <bernhard.rosenkranzer@linaro.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 1/1] perf: Port to Android
References: <1408973.PFKjjaXiS1@localhost.localdomain> <CAOJsxLFgvqJUwwnrtH8b9eOfNzUEZDmQGP1FVvToitD6ayYP0g@mail.gmail.com>
In-Reply-To: <CAOJsxLFgvqJUwwnrtH8b9eOfNzUEZDmQGP1FVvToitD6ayYP0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/12 2:51 PM, Pekka Enberg wrote:
>> +#ifdef ANDROID
>> +/* While stdlib.h has a prototype for it,
>> +   Bionic doesn't actually implement on_exit() */
>> +#ifndef ATEXIT_MAX
>> +#define ATEXIT_MAX 32
>> +#endif
>> +static int __on_exit_count = 0;
>> +typedef void (*on_exit_func_t)(int, void*);
>> +static on_exit_func_t __on_exit_funcs[ATEXIT_MAX];
>> +static void *__on_exit_args[ATEXIT_MAX];
>> +static int __exitcode = 0;
>> +static void __handle_on_exit_funcs();
>> +static int on_exit(on_exit_func_t function, void *arg);
>> +#define exit(x) (exit)(__exitcode = (x))
>> +
>> +static int on_exit(on_exit_func_t function, void *arg) {
>> +       if(__on_exit_count == ATEXIT_MAX)
>> +               return ENOMEM;
>> +       else if(__on_exit_count == 0)
>> +               atexit(__handle_on_exit_funcs);
>> +       __on_exit_funcs[__on_exit_count] = function;
>> +       __on_exit_args[__on_exit_count++] = arg;
>> +       return 0;
>> +}
>> +
>> +static void __handle_on_exit_funcs() {
>> +       for(int i=0; i<__on_exit_count; i++) {
>> +               __on_exit_funcs[i](__exitcode, __on_exit_args[i]);
>> +       }
>> +}
>> +#endif
>> +

Why not add support for the missing functions (on_exit, getsid, psignal 
and getline) to Bionic instead of perf?


>> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
>> index 0f99f39..77c5ced 100644
>> --- a/tools/perf/util/util.h
>> +++ b/tools/perf/util/util.h
>> @@ -70,15 +70,19 @@
>>   #include <sys/socket.h>
>>   #include <sys/ioctl.h>
>>   #include <sys/select.h>
>> +#ifndef ANDROID
>>   #include <netinet/in.h>
>>   #include <netinet/tcp.h>
>>   #include <arpa/inet.h>
>> +#endif
>>   #include <netdb.h>

netinet/*, arpa/inet.h,netdb.h and sys/socket.h can be removed from util.h

David

