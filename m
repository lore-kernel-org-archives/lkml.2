Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1GLXBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:01:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab1GLXBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:01:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=aqaeHYdv+MlAXij5y79XUJoCf02+tpQdVAzB93i4vgas6nFd77VOU5VidGybthiPT
	EpMldgIeNjn0zS4fJY/lw==
MIME-Version: 1.0
In-Reply-To: <1310511415.3931.11.camel@gandalf.stny.rr.com>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org> <1310511415.3931.11.camel@gandalf.stny.rr.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Tue, 12 Jul 2011 16:01:11 -0700
X-Google-Sender-Auth: ZKl3s5zVG2XK0eZ0YT7iefOfJs4
Message-ID: <CAPz6YkWhf-6U_s=ZaLZx6i2DUa7-TgBcs4f08T6XACrwqDHaww@mail.gmail.com>
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
To: Steven Rostedt <rostedt@goodmis.org>
Cc: acme@redhat.com, anton@samba.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 3:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-07-12 at 14:15 -0700, Sonny Rao wrote:
>> While attempting to create a timechart of boot up I found
>> perf didn't tolerate modules being loaded/unloaded.  This patch
>> fixes this by reading the file once and then writing the size
>> read at the correct point in the file.  It also simplifies the
>> code somewhat.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>
>>  static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
>> @@ -338,14 +292,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
>>               sprintf(format, "%s/%s/format", sys, dent->d_name);
>>               ret = stat(format, &st);
>>
>> -             if (ret >= 0) {
>> -                     /* unfortunately, you can not stat debugfs files for size */
>> -                     size = get_size(format);
>> -                     write_or_die(&size, 8);
>> -                     check_size = copy_file(format);
>> -                     if (size != check_size)
>> -                             die("error in size of file '%s'", format);
>
> You mean to tell me that you are hitting a race between the get_size()
> and check_size()?  This is a very quick action, and this only happens at
> start up. Are you starting up perf and loading modules at the same time?

I sure am... the thing we're trying to do here is analyze our boot time
and udev is asynchronously loading modules in the background while
perf is starting up.

We've put in stupid hacks like sleep for a while, but they've proven to be
unreliable so I figured I'd take a stab at fixing the issue.  I also think this
change will make the overhead a bit lower since we only read these files
once.

Sonny
