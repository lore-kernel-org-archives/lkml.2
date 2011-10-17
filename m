Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1JQOta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:49:30 -0400
Received: from bubo.tul.cz ([147.230.16.1]:52175 "EHLO bubo.tul.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1JQOt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:49:29 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: linux-kernel@vger.kernel.org
References: <op.v3aeassn4x40tt@localhost>
 <20111013172958.GD18574@ponder.secretlab.ca>
Subject: Re: [RFC][PATCH][TRIVIAL] System ACE fails in look for root devices
To: "Grant Likely" <grant.likely@secretlab.ca>
Date: Mon, 17 Oct 2011 16:49:24 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Petr Cvek" <petr.cvek@tul.cz>
Organization: TUL
Message-ID: <op.v3h3gmqu4x40tt@localhost>
In-Reply-To: <20111013172958.GD18574@ponder.secretlab.ca>
User-Agent: Opera Mail/10.63 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay. I had lot of work.

> However, of_property_read_u32() can only accept a u32 value, not an
> int, so this needs to be solved with two variables to be correct:
>
> 	int id;
> 	u32 tmp;
> 	id = dev->id;
> 	if (of_property_read_u32(dev->dev.of_node, "port-number", &tmp)
> 		id = tmp;
> 	if (id < 0)
> 		id = 0;
>

I think of_property_read_u32() returns nonzero, when not found (-ENODATA),  
therefore:

	if (! of_property_read_u32(dev->dev.of_node, "port-number", &tmp))

> It's not as pretty, but it is a limitation of how of_property_read_u32
> has to be implemented.  I hope to find a better way to do it that
> doesn't have the u32 restriction on the return value.

I hope, nobody will use port-number bigger than max(int) :-D. Oh and I  
would improve code to something like this:

	int id;
	u32 tmp;
	if (! of_property_read_u32(dev->dev.of_node, "port-number", &tmp))  
{	/*when return 0, use tmp val*/
	  id = tmp;			/*always >0 */
	} else {			/* when error, use dev->id and test >0 */
	  id = dev->id;
	  if (id < 0)
	    id = 0;
	}

Petr
