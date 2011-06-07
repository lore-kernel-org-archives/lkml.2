Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1FGPp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:45:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22312 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1FGPpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tYN+TItujUNUgD+i8FUpJE2ogqm6jNmBODiCPnT+6qU5YqVlU42IlkCEE76hIsEgfB
         Jsh9emSKTAguG9T+a5Uw==
MIME-Version: 1.0
In-Reply-To: <20110606173251.GJ2391@elte.hu>
References: <20110606151024.GA9464@quad>
	<20110606173251.GJ2391@elte.hu>
Date: Tue, 7 Jun 2011 17:45:08 +0200
Message-ID: <BANLkTik52KDNf3ANFdWxO9ey-fhCSxC0jQ@mail.gmail.com>
Subject: Re: [PATCH] perf: fix missing event name init for default event
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 7:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> @@ -87,6 +87,13 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
>>       if (evsel == NULL)
>>               return -ENOMEM;
>>
>> +     /* use strdup() because free(evsel) assumes name is allocated */
>> +     evsel->name = strdup("cycles");
>> +     if (!evsel->name) {
>> +             free(evsel);
>> +             return -ENOMEM;
>> +     }
>> +
>>       perf_evlist__add(evlist, evsel);
>>       return 0;
>>  }
>
> Hm, nice fix, but this function should really follow the standard
> exception tear-down sequence pattern we use in the kernel:
>
Fine, I can respin that patch.

>        if (evsel == NULL)
>                goto err;
>
>        ...
>
>        if (!evsel->name)
>                goto err_free;
>
>        ...
>
>        return 0;
>
> err_free:
>        free(evsel);
> err:
>        return -ENOMEM;
>
> Thanks,
>
>        Ingo
>
