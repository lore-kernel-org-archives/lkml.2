Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0CRQ4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:56:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63084 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0CRQ4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LfV0pHGzE+62GM22eEwi7SyI0kkKaRBEPADI2taMROXIIkBToI+xzZL8uBcnkv7W7n
         BR32KkAoKqzq6zpoPeYxf0v1p1hPorehhLgKB7N1Bt1UblnkDmVyZzuNKUSfZ5ILDkC0
         ez5tC+EVk1Y4z8LwKpIuukdI2FT9DUCa0ModI=
MIME-Version: 1.0
In-Reply-To: <1268924167.32426.90.camel@gandalf.stny.rr.com>
References: <1268920132-30512-1-git-send-email-chase.douglas@canonical.com>
	 <1268924167.32426.90.camel@gandalf.stny.rr.com>
Date: Thu, 18 Mar 2010 12:27:28 -0400
X-Google-Sender-Auth: 42fc35ad8b604aa8
Message-ID: <40ec3ea41003180927y52bae53hfb8aca0d00ac8de8@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add tracing_off_event() to stop tracing when a bug or 
	warning occur
From: Chase Douglas <chase.douglas@canonical.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 10:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> [ Expanded the Cc list ]
>
> On Thu, 2010-03-18 at 09:48 -0400, Chase Douglas wrote:
>> The tracing_off_event() function calls tracing_off() to stop tracing
>> when an event occurs. By default, only BUG-type events stop tracing,
>> while WARNING type events do not. This is controlled through the
>> tracing_off={none,warn,bug} commandline parameter.
>>
>> Call this function from bug and warning event handlers to enable a user
>> to debug their kernel by starting a trace, hitting an event, and then
>> retrieving trace info knowing that the trace was stopped right after the
>> event was hit.
>>
>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> ---
>>  include/linux/kernel.h     |    5 +++++
>>  kernel/trace/ring_buffer.c |   34 ++++++++++++++++++++++++++++++++++
>>  2 files changed, 39 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 7f07074..107091f 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -478,16 +478,21 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>>   *
>>   * Most likely, you want to use tracing_on/tracing_off.
>>   */
>> +#define TRACE_EVENT_BUG 0
>> +#define TRACE_EVENT_WARN 1
>
> This should probably be an enum.
>
>> +
>>  #ifdef CONFIG_RING_BUFFER
>>  void tracing_on(void);
>>  void tracing_off(void);
>>  /* trace_off_permanent stops recording with no way to bring it back */
>>  void tracing_off_permanent(void);
>> +void tracing_off_event(long event);
>>  int tracing_is_on(void);
>>  #else
>>  static inline void tracing_on(void) { }
>>  static inline void tracing_off(void) { }
>>  static inline void tracing_off_permanent(void) { }
>> +static inline void tracing_off_event(long event) { }
>>  static inline int tracing_is_on(void) { return 0; }
>>  #endif
>>  #ifdef CONFIG_TRACING
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index 0287f9f..b148862 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -193,6 +193,40 @@ void tracing_off_permanent(void)
>>       set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
>>  }
>>
>> +static long tracing_event_mask = TRACE_EVENT_BUG;
>
> That's a bad name. It does not seem to be a mask but seems to be a
> control setting. Maybe call it tracing_event_off_ctrl ?

I'll fix these two things up and resend.

Thanks,
Chase
