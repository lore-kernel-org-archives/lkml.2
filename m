Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0LGKGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:06:37 -0500
Received: from posthamster.phnxsoft.com ([89.1.7.4]:2735 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0LGKGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:06:36 -0500
Message-ID: <4CFE0723.8010603@phoenixsoftware.de>
Date: Tue, 07 Dec 2010 11:06:27 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Organization: Phoenix Software GmbH
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.14) Gecko/20100930 SeaMonkey/2.0.9
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/45] kstrtox: convert drivers/isdn/
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com> <1291571382-2719-26-git-send-email-adobriyan@gmail.com> <4CFC2A05.7010509@phoenixsoftware.de> <20101206201008.GA5650@core2.telecom.by>
In-Reply-To: <20101206201008.GA5650@core2.telecom.by>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2010-12-06 21:10 schrieb Alexey Dobriyan:
> On Mon, Dec 06, 2010 at 01:10:45AM +0100, Tilman Schmidt wrote:
>> I like the patch, but why not go all the way?
>>
>> Am 05.12.2010 18:49 schrieb Alexey Dobriyan:
>>> @@ -566,10 +566,10 @@ void gigaset_handle_modem_response(struct cardstate *cs)
>>>  		case RT_ZCAU:
>>>  			event->parameter = -1;
>>>  			if (curarg + 1 < params) {
>>> -				unsigned long type, value;
>>> +				u8 type, value;
>>>  
>>> -				i = strict_strtoul(argv[curarg++], 16, &type);
>>> -				j = strict_strtoul(argv[curarg++], 16, &value);
>>> +				i = kstrtou8(argv[curarg++], 16, &type);
>>> +				j = kstrtou8(argv[curarg++], 16, &value);
>>>  
>>>  				if (i == 0 && type < 256 &&
>>>  				    j == 0 && value < 256)
>>
>> Once type and value are u8, the checks for < 256 are unnecessary.
> 
> OK.
> 
>>> @@ -583,7 +583,7 @@ void gigaset_handle_modem_response(struct cardstate *cs)
>>>  				unsigned long res;
>>>  				int rc;
>>>  
>>> -				rc = strict_strtoul(argv[curarg++], 10, &res);
>>> +				rc = kstrtoul(argv[curarg++], 10, &res);
>>>  				if (rc == 0)
>>>  					event->parameter = res;
>>>  			}
>>
>> The new kstrtoul() promises not to touch the result field in the event
>> of a conversion error, so &event->parameter can be passed directly to
>> it, getting rid of the variables rc and res and the if statement.
> 
> What should be done in case of error?

The same as now: leave event->parameter alone. It's preset to -1
which will later be interpreted as "erroneous or missing value".

> Compiler will warn if kstrto*() result is unused:
> 
> 	kstrtoul(argv[curarg++], 10, &event->parameter);

That's annoying of course. Perhaps silence the warning with some
innocuous pro forma activity like emitting a message:

	if (kstrtoul(argv[curarg++], 10, &event->parameter))
		dev_warn(cs->dev, "bad number");

Or rearrange the code to assign -1 only after an error is
detected, like so:

@@ -578,15 +578,9 @@ void gigaset_handle_modem_response(struct cardstate *cs)
                                curarg = params - 1;
                        break;
                case RT_NUMBER:
-                       event->parameter = -1;
-                       if (curarg < params) {
-                               unsigned long res;
-                               int rc;
-
-                               rc = strict_strtoul(argv[curarg++], 10, &res);
-                               if (rc == 0)
-                                       event->parameter = res;
-                       }
+                       if (curarg >= params ||
+                           kstrtoul(argv[curarg], 10, &event->parameter))
+                               event->parameter = -1;
                        gig_dbg(DEBUG_EVENT, "parameter==%d", event->parameter);
                        break;
                }

Thanks,
Tilman

-- 
Tilman Schmidt
Phoenix Software GmbH
Bonn, Germany
