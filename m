Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0HUVHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 17:07:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40837 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0HUVHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 17:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cWORFpqMW4UaQUtALFlMw3CESygxsBEz6JDUEBkd2/HsZFJOJguqy6L1FEJa6g7RPx
         vMppgW7yLOBINhjtACd7IeeABVsIiwmU46qhUvdMEIRXTKoeRXJ+WbDjV+Pmr1vGdaY7
         iQG1gk0bRn9znX5ekgdIED0bPvrKCVg3AYdCs=
MIME-Version: 1.0
In-Reply-To: <AANLkTimtwc28BzpxzEhNSMH2TiDvZwxKrOyiOfv8r2kZ@mail.gmail.com>
References: <AANLkTikEMfVE0FaT_se5H1yq7FOKi0gu8qbRMB0c8JKJ@mail.gmail.com>
	<AANLkTiktWtAefkAWJNDnSx9SKf_hAOHqcHeEAXV0ARj3@mail.gmail.com>
	<AANLkTimtwc28BzpxzEhNSMH2TiDvZwxKrOyiOfv8r2kZ@mail.gmail.com>
Date: Sat, 21 Aug 2010 23:07:32 +0200
Message-ID: <AANLkTikgWSCKiPHiXG-Sj=LBFp2U8h=XA_vORRoqGpYz@mail.gmail.com>
Subject: Re: Using block layer's I/O context api (block/blk-ioc.c) without CFQ.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: =?UTF-8?Q?Pedro_Eug=C3=AAnio_Rocha?= 
	<pedro.eugenio.rocha@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/21 Pedro Eugênio Rocha <pedro.eugenio.rocha@gmail.com>:
> Thanks for your reply,
>
> 2010/8/20 Corrado Zoccolo <czoccolo@gmail.com>:
>> 2010/8/19 Pedro Eugênio Rocha <pedro.eugenio.rocha@gmail.com>:
>>> Hi,
>> Hi,
>>>
>>> Is there a way to use the generic block layer I/O context api
>>> (block/blk-ioc.c), without
>>> using cfq specific functions and structs? I'm writing an I/O scheduler
>>> for my master
>>> thesis, and I'd like to use my own functions for I/O context handling,
>>> not cfq's. Sorry
>>> if I'm missing something here.
>> Sure. I think you can get an idea by grabbing an old enough kernel
>> that still has anticipatory scheduler (if I recall correctly, 2.6.32
>> should have it), and look at its functions.
>
> In mainstream kernel as in 2.6.32, it's used a generic get_io_context
> function to get the current task io_context. In addition, you can create
> a function like cfq_get_io_context to implement some scheduler
> specific stuff. Oh right so far.
>
> But when the task is exiting there is an exit_io_context function, which
> calls put_io_context. This function calls cfq_dtor, which seems to be
> an specific cfq function, and maybe will not work with others I/O
> schedulers. My newbie question is, those block/blk-ioc.c functions
> are  supposed to be generic, or my scheduler should implement it's
> own?
Cfq and AS required extending the basic io_context to add per-process
statistics. Therefore, cfq_io_context and as_io_context were added to
the io_context, and proper deallocation is done when deallocating
io_context (as_io_context is deallocated via its dtor function pointer
just before calling cfq_dtor).
If your I/O scheduler requires storing some stats per process, you
have the choice of either reusing one of the existing as/cfq
io_context extensions, or define your own (and in that case, you
should add your destructor as well).
>
>
>> Or you can look at my post:
>> http://lists.openwall.net/linux-kernel/2009/06/08/387, where I
>> implemented a proof-of-concept I/O scheduler based on anticipatory
>> scheduler. Most of the concepts in that scheduler were later ported to
>> CFQ.
>> Do you already have a scheduling algorithm in mind? And what will be
>> your main purpose/target?
>>
>
> Yes. Our main purpose is to share disk I/O bandwidth among
> processes/tasks/cgroups/whatever providing strong QoS guarantees, such
> as bandwidth, bursts and latency. It borrows many ideas from bfq and
> pClock I/O schedulers. The implementation will be just a proof-of-concept,
> not something you can use in a real environment. =)

Sounds interesting. Do you plan to have simulations before the real
implementation, and what are your reference workloads?

Cheers,
Corrado

> Thanks for your help!
>
>> Thanks
>> Corrado
>>>
>>> Thanks,
>>>
>>> Pedro Eugênio Rocha
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
>>
>> --
>> __________________________________________________________________________
>>
>> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
>> PhD - Department of Computer Science - University of Pisa, Italy
>> --------------------------------------------------------------------------
>> The self-confidence of a warrior is not the self-confidence of the average
>> man. The average man seeks certainty in the eyes of the onlooker and calls
>> that self-confidence. The warrior seeks impeccability in his own eyes and
>> calls that humbleness.
>>                                Tales of Power - C. Castaneda
>>
>
>
>
> --
> Pedro Eugênio Rocha
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
