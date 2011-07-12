Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab1GLHju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:39:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56958 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1GLHjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:39:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-pZPsbnpjnFzCQFxWrAtoeG71pn1wVqjcOrR9yBQ3L1nA@mail.gmail.com>
References: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
 <CAO+b5-rP8JAqe5pV7x_4RR5aumpHi4JG5diHehe5BiS_QwzSvw@mail.gmail.com>
 <CAJfuBxxvDhRgwfosZHZEAsgeLsAzDigHh-j3mC+8aJByR-=GkQ@mail.gmail.com> <CAO+b5-pZPsbnpjnFzCQFxWrAtoeG71pn1wVqjcOrR9yBQ3L1nA@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 12 Jul 2011 01:39:19 -0600
Message-ID: <CAJfuBxwET2zVWBJCBsUsEu661h+rzfHhtgvRY7SuBG7nPQLZnw@mail.gmail.com>
Subject: Re: [ patch 00/21 ] support multiple, pending ddebugs at kernel-boot
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:53 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 11, 2011 at 9:06 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> On Mon, Jul 11, 2011 at 12:30 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>> As far as I can see with v2 of this patch set a query gets on the
>>> pending list if either +a has been specified or no matches were found
>>> the first time a query is run. Are both mechanisms necessary ? If not,
>>> I propose to leave out the second. That will not only allow to
>>> simplify the code somewhat but will also reduce confusion for
>>> dynamic_printk users.
>>>
>>
>> Both conditions are necessary:
>> - 'a' flag required,
>> - query not directly applicable.
>>
>> root@voyage:~# echo "module nosuch +p" > /dbg/dynamic_debug/control
>> root@voyage:~# cat /sys/module/dynamic_debug/parameters/pending_ct
>> 0
>>
>> root@voyage:~# echo "module nosuch +ap" > /dbg/dynamic_debug/control
>> root@voyage:~# cat /sys/module/dynamic_debug/parameters/pending_ct
>> 1
>
> The above example contradicts the following code added in patch 09/21:
>
>        /* actually go and implement the change */
>        nfound = ddebug_change(&query, flags, mask);
> +
> +       pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
> +       if (!nfound)
> +               return ddebug_save_pending(&query, flags, mask);
> +
>        return 0;
>
> Bart.
>

In patch 13, that becomes

+	if (!nfound) {
+		if (flags & _DPRINTK_FLAGS_APPEND)
+			return ddebug_save_pending(&query, flags, mask);
+		else
+			pr_warn("no match on: %s\n",
+				show_ddebug_query(&query));
+	}
 	return 0;
 }


its altered once more, when I add filter-flags,
but that doesnt really change my assertion.

 	nfound = ddebug_change(&query, flags, mask, filter);
 	if (!nfound) {
-		if (flags & _DPRINTK_FLAGS_APPEND)
+		if (flags & _DPRINTK_FLAGS_APPEND ||
+			filter & _DPRINTK_FLAGS_APPEND)
 			rc = ddebug_save_pending(&query, flags, mask);
