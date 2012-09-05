Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2IEOJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:09:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62768 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2IEOJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120905134937.GN19591@arwen.pp.htv.fi>
References: <CADu=CFrNXPJV-DiMT0Ruw6jZNhbsqg+uwP6UQnu-xrAVMc7mQg@mail.gmail.com>
	<20120905134937.GN19591@arwen.pp.htv.fi>
Date: Wed, 5 Sep 2012 22:09:06 +0800
Message-ID: <CADu=CFq2c4j5-n5Ah+JeLT+WR+TZkjraDs6th=S9XR2x5cSgwQ@mail.gmail.com>
Subject: Re: [PATCH] perf tool: fix trivial memory leak while calling system_path()
From: liang xie <xieliang007@gmail.com>
To: balbi@ti.com
Cc: acme@ghostprotocols.net, mingo@elte.hu, paulus@samba.org,
        linux-perf-users@vger.kernel.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Thanks for reviewing! yeh, the check could be removed safely .
For casting, it'll complain like this if removed:
cc1: warnings being treated as errors
util/help.c: In function ‘load_command_list’:
util/help.c:190: error: passing argument 1 of ‘free’ discards
qualifiers from pointer target type
/usr/include/stdlib.h:488: note: expected ‘void *’ but argument is of
type ‘const char *’
make: *** [util/help.o] Error 1

Best Regards,

On Wed, Sep 5, 2012 at 9:49 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Sep 05, 2012 at 09:48:54PM +0800, liang xie wrote:
>> A trivial memory leak fix while calling system_path
>>
>> Signed-off-by: Liang Xie <xieliang@xiaomi.com>
>> ---
>>  tools/perf/util/exec_cmd.c |    6 ++++--
>>  tools/perf/util/help.c     |    1 +
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
>> index 7adf4ad..790cc95 100644
>> --- a/tools/perf/util/exec_cmd.c
>> +++ b/tools/perf/util/exec_cmd.c
>> @@ -83,8 +83,8 @@ void setup_path(void)
>>  {
>>       const char *old_path = getenv("PATH");
>>       struct strbuf new_path = STRBUF_INIT;
>> -
>> -     add_path(&new_path, perf_exec_path());
>> +     const char *exec_path = perf_exec_path();
>> +     add_path(&new_path, exec_path);
>>       add_path(&new_path, argv0_path);
>>
>>       if (old_path)
>> @@ -95,6 +95,8 @@ void setup_path(void)
>>       setenv("PATH", new_path.buf, 1);
>>
>>       strbuf_release(&new_path);
>> +     if (exec_path)
>
> free(NULL) is safe, the check isn't needed.
>
>> +             free((void *)exec_path);
>
> this cast doesn't look necessary either.
>
> --
> balbi
