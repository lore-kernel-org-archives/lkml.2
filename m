Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1G2RmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:42:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1G2RmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:42:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=e4AN+lTz0E0L3SwXRVaez8ezoXHtxn8iIDYKsekHRN2pa2jVV9Nhmir6mKcaoskPO
	Kev+56oeOWGK1dNO2jPng==
MIME-Version: 1.0
In-Reply-To: <1311949173.21143.43.camel@gandalf.stny.rr.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
 <1311619188-4905-1-git-send-email-vnagarnaik@google.com> <1311949173.21143.43.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Jul 2011 10:41:39 -0700
Message-ID: <CAL26m8Jmy=Rcg6fKghk9Epcj9U6Z2i9UM78hF5_r30U5Qvv9uw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] trace-cmd: Add parse error checking target
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 7:19 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-07-25 at 11:39 -0700, Vaibhav Nagarnaik wrote:
>> Add another target 'check-events' which parses all the event formats and
>> returns whether there are any issues with the print format strings.
>>
>> With an error in the format, the return value is 22 (EINVAL) and for
>> success, it is 0.
>
> Could you write up a man page for this too?
>
>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> ---
>> Changelog v2-v1:
>> * Pass any parsing failures in pevent structure
>>
>>  parse-events.h |    2 ++
>>  trace-cmd.c    |   25 +++++++++++++++++++++++++
>>  trace-usage.c  |    5 +++++
>>  trace-util.c   |   36 ++++++++++++++++++++++++++----------
>>  4 files changed, 58 insertions(+), 10 deletions(-)
>>
>> diff --git a/parse-events.h b/parse-events.h
>> index c32d715..f5cab15 100644
>> --- a/parse-events.h
>> +++ b/parse-events.h
>> @@ -402,6 +402,8 @@ struct pevent {
>>       struct event_handler *handlers;
>>       struct pevent_function_handler *func_handlers;
>>
>> +     int parsing_failures;
>> +
>>       /* cache */
>>       struct event_format *last_event;
>>  };
>> diff --git a/trace-cmd.c b/trace-cmd.c
>> index bff5bbf..5cfd97f 100644
>> --- a/trace-cmd.c
>> +++ b/trace-cmd.c
>> @@ -158,6 +158,31 @@ int main (int argc, char **argv)
>>       } else if (strcmp(argv[1], "stack") == 0) {
>>               trace_stack(argc, argv);
>>               exit(0);
>> +     } else if (strcmp(argv[1], "check-events") == 0) {
>> +             char *tracing;
>> +             int ret;
>> +             struct pevent *pevent = NULL;
>> +
>> +             tracing = tracecmd_find_tracing_dir();
>> +
>> +             if (!tracing) {
>> +                     printf("Can not find or mount tracing directory!\n"
>> +                             "Either tracing is not configured for this "
>> +                             "kernel\n"
>> +                             "or you do not have the proper permissions to "
>> +                             "mount the directory");
>> +                     exit(EINVAL);
>> +             }
>> +
>> +             ret = 0;
>> +             pevent = tracecmd_local_events(tracing);
>> +             if (!pevent)
>> +                     exit(EINVAL);
>> +             if (pevent->parsing_failures)
>> +                     ret = EINVAL;
>
> Hmm, what about doing:
>
>        if (!pevent || pevent->parsing_failures)
>                ret = EINVAL;
>
>
>
>> +             pevent_free(pevent);
>
> And allow pevent_free() to take a NULL pointer?
>
> Hmm, I'll just apply this patch and then make the update. But could you
> still send a man page patch?

Thanks Steve. I will send the man page patch.

Vaibhav Nagarnaik
