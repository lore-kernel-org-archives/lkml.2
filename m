Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0F2UYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0F2UYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:24:31 -0400
Subject: Race in wb_do_writeback() ???
From: Larry Woodman <lwoodman@redhat.com>
To: hch@infradead.org, linux-kernel@vger.kernel.org, riel@redhat.com
Content-Type: text/plain
Date: Tue, 29 Jun 2010 16:28:16 -0400
Message-Id: <1277843296.3223.98.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chistoph, I am seeing slabcache corruption.  wb_do_writeback() calls
wb_clear_pending() which can queue up the freeing of the bdi_work. Then
it calls wb_writeback() which can block, resulting in using the bdi_work
after its freed.

------------------------------------------------------------------
  /*
   * If this isn't a data integrity operation, just notify
   * that we have seen this work and we are now starting it.
   */
  if (!test_bit(WS_ONSTACK, &work->state))
         wb_clear_pending(wb, work);

  wrote += wb_writeback(wb, &args);

 /*
  * This is a data integrity writeback, so only do the
  * notification when we have completed the work.
  */
  if (test_bit(WS_ONSTACK, &work->state))
         wb_clear_pending(wb, work);
------------------------------------------------------------------

Can you have one unconditional call to wb_clear_pending() after the
calling wb_writeback()???

Larry


