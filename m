Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0EJIb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:31:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0EJIbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:31:53 -0400
Message-ID: <4BE7C4E5.90408@cn.fujitsu.com>
Date: Mon, 10 May 2010 16:33:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 9/8] xconfig: add support to show hidden options which
 have prompts
References: <4BE3AB91.80606@cn.fujitsu.com>
In-Reply-To: <4BE3AB91.80606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature has been supported in menuconfig and gconfig, so
here add it to xconfig.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

(This patch is based on the previous patchset I sent several days ago.)

Randy, I've fixed the bug you reported. The bug was seen only
in split view.

---
 scripts/kconfig/qconf.cc |   69 +++++++++++++++++++++++++++++++++------------
 scripts/kconfig/qconf.h  |   16 ++++++++--
 2 files changed, 62 insertions(+), 23 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 47cdeae..d0b1958 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -148,7 +148,7 @@ void ConfigItem::updateMenu(void)
 	case S_TRISTATE:
 		char ch;
 
-		if (!sym_is_changable(sym) && !list->showAll) {
+		if (!sym_is_changable(sym) && list->optMode == normalOpt) {
 			setPixmap(promptColIdx, 0);
 			setText(noColIdx, QString::null);
 			setText(modColIdx, QString::null);
@@ -319,7 +319,7 @@ ConfigList::ConfigList(ConfigView* p, const char *name)
 	  symbolYesPix(xpm_symbol_yes), symbolModPix(xpm_symbol_mod), symbolNoPix(xpm_symbol_no),
 	  choiceYesPix(xpm_choice_yes), choiceNoPix(xpm_choice_no),
 	  menuPix(xpm_menu), menuInvPix(xpm_menu_inv), menuBackPix(xpm_menuback), voidPix(xpm_void),
-	  showAll(false), showName(false), showRange(false), showData(false),
+	  showName(false), showRange(false), showData(false), optMode(normalOpt),
 	  rootEntry(0), headerPopup(0)
 {
 	int i;
@@ -336,10 +336,10 @@ ConfigList::ConfigList(ConfigView* p, const char *name)
 
 	if (name) {
 		configSettings->beginGroup(name);
-		showAll = configSettings->readBoolEntry("/showAll", false);
 		showName = configSettings->readBoolEntry("/showName", false);
 		showRange = configSettings->readBoolEntry("/showRange", false);
 		showData = configSettings->readBoolEntry("/showData", false);
+		optMode = (enum optionMode)configSettings->readNumEntry("/optionMode", false);
 		configSettings->endGroup();
 		connect(configApp, SIGNAL(aboutToQuit()), SLOT(saveSettings()));
 	}
@@ -351,6 +351,17 @@ ConfigList::ConfigList(ConfigView* p, const char *name)
 	reinit();
 }
 
+bool ConfigList::menuSkip(struct menu *menu)
+{
+	if (optMode == normalOpt && menu_is_visible(menu))
+		return false;
+	if (optMode == promptOpt && menu_has_prompt(menu))
+		return false;
+	if (optMode == allOpt)
+		return false;
+	return true;
+}
+
 void ConfigList::reinit(void)
 {
 	removeColumn(dataColIdx);
@@ -379,7 +390,7 @@ void ConfigList::saveSettings(void)
 		configSettings->writeEntry("/showName", showName);
 		configSettings->writeEntry("/showRange", showRange);
 		configSettings->writeEntry("/showData", showData);
-		configSettings->writeEntry("/showAll", showAll);
+		configSettings->writeEntry("/optionMode", (int)optMode);
 		configSettings->endGroup();
 	}
 }
@@ -605,7 +616,7 @@ void ConfigList::updateMenuList(P* parent, struct menu* menu)
 		}
 
 		visible = menu_is_visible(child);
-		if (showAll || visible) {
+		if (!menuSkip(child)) {
 			if (!child->sym && !child->list && !child->prompt)
 				continue;
 			if (!item || item->menu != child)
@@ -834,7 +845,10 @@ void ConfigList::contextMenuEvent(QContextMenuEvent *e)
 		e->ignore();
 }
 
-ConfigView* ConfigView::viewList;
+ConfigView*ConfigView::viewList;
+QAction *ConfigView::showNormalAction;
+QAction *ConfigView::showAllAction;
+QAction *ConfigView::showPromptAction;
 
 ConfigView::ConfigView(QWidget* parent, const char *name)
 	: Parent(parent, name)
@@ -859,13 +873,16 @@ ConfigView::~ConfigView(void)
 	}
 }
 
-void ConfigView::setShowAll(bool b)
+void ConfigView::setOptionMode(QAction *act)
 {
-	if (list->showAll != b) {
-		list->showAll = b;
-		list->updateListAll();
-		emit showAllChanged(b);
-	}
+	if (act == showNormalAction)
+		list->optMode = normalOpt;
+	else if (act == showAllAction)
+		list->optMode = allOpt;
+	else
+		list->optMode = promptOpt;
+
+	list->updateListAll();
 }
 
 void ConfigView::setShowName(bool b)
@@ -1348,11 +1365,24 @@ ConfigMainWindow::ConfigMainWindow(void)
 	  connect(showDataAction, SIGNAL(toggled(bool)), configView, SLOT(setShowData(bool)));
 	  connect(configView, SIGNAL(showDataChanged(bool)), showDataAction, SLOT(setOn(bool)));
 	  showDataAction->setOn(configList->showData);
-	QAction *showAllAction = new QAction(NULL, _("Show All Options"), 0, this);
-	  showAllAction->setToggleAction(TRUE);
-	  connect(showAllAction, SIGNAL(toggled(bool)), configView, SLOT(setShowAll(bool)));
-	  connect(showAllAction, SIGNAL(toggled(bool)), menuView, SLOT(setShowAll(bool)));
-	  showAllAction->setOn(configList->showAll);
+
+	QActionGroup *optGroup = new QActionGroup(this);
+	optGroup->setExclusive(TRUE);
+	connect(optGroup, SIGNAL(selected(QAction *)), configView,
+		SLOT(setOptionMode(QAction *)));
+	connect(optGroup, SIGNAL(selected(QAction *)), menuView,
+		SLOT(setOptionMode(QAction *)));
+
+	configView->showNormalAction = new QAction(NULL, _("Show Normal Options"), 0, optGroup);
+	configView->showAllAction = new QAction(NULL, _("Show All Options"), 0, optGroup);
+	configView->showPromptAction = new QAction(NULL, _("Show Prompt Options"), 0, optGroup);
+	configView->showNormalAction->setToggleAction(TRUE);
+	configView->showNormalAction->setOn(configList->optMode == normalOpt);
+	configView->showAllAction->setToggleAction(TRUE);
+	configView->showAllAction->setOn(configList->optMode == allOpt);
+	configView->showPromptAction->setToggleAction(TRUE);
+	configView->showPromptAction->setOn(configList->optMode == promptOpt);
+
 	QAction *showDebugAction = new QAction(NULL, _("Show Debug Info"), 0, this);
 	  showDebugAction->setToggleAction(TRUE);
 	  connect(showDebugAction, SIGNAL(toggled(bool)), helpText, SLOT(setShowDebug(bool)));
@@ -1395,7 +1425,8 @@ ConfigMainWindow::ConfigMainWindow(void)
 	showRangeAction->addTo(optionMenu);
 	showDataAction->addTo(optionMenu);
 	optionMenu->insertSeparator();
-	showAllAction->addTo(optionMenu);
+	optGroup->addTo(optionMenu);
+	optionMenu->insertSeparator();
 	showDebugAction->addTo(optionMenu);
 
 	// create help menu
@@ -1490,7 +1521,7 @@ void ConfigMainWindow::setMenuLink(struct menu *menu)
 	ConfigList* list = NULL;
 	ConfigItem* item;
 
-	if (!menu_is_visible(menu) && !configView->showAll())
+	if (configList->menuSkip(menu))
 		return;
 
 	switch (configList->mode) {
diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
index b3b5657..a7f2686 100644
--- a/scripts/kconfig/qconf.h
+++ b/scripts/kconfig/qconf.h
@@ -44,6 +44,9 @@ enum colIdx {
 enum listMode {
 	singleMode, menuMode, symbolMode, fullMode, listMode
 };
+enum optionMode {
+	normalOpt = 0, allOpt, promptOpt
+};
 
 class ConfigList : public QListView {
 	Q_OBJECT
@@ -115,6 +118,8 @@ public:
 	void setAllOpen(bool open);
 	void setParentMenu(void);
 
+	bool menuSkip(struct menu *);
+
 	template <class P>
 	void updateMenuList(P*, struct menu*);
 
@@ -124,8 +129,9 @@ public:
 	QPixmap choiceYesPix, choiceNoPix;
 	QPixmap menuPix, menuInvPix, menuBackPix, voidPix;
 
-	bool showAll, showName, showRange, showData;
+	bool showName, showRange, showData;
 	enum listMode mode;
+	enum optionMode optMode;
 	struct menu *rootEntry;
 	QColorGroup disabledColorGroup;
 	QColorGroup inactivedColorGroup;
@@ -222,17 +228,15 @@ public:
 	static void updateList(ConfigItem* item);
 	static void updateListAll(void);
 
-	bool showAll(void) const { return list->showAll; }
 	bool showName(void) const { return list->showName; }
 	bool showRange(void) const { return list->showRange; }
 	bool showData(void) const { return list->showData; }
 public slots:
-	void setShowAll(bool);
 	void setShowName(bool);
 	void setShowRange(bool);
 	void setShowData(bool);
+	void setOptionMode(QAction *);
 signals:
-	void showAllChanged(bool);
 	void showNameChanged(bool);
 	void showRangeChanged(bool);
 	void showDataChanged(bool);
@@ -242,6 +246,10 @@ public:
 
 	static ConfigView* viewList;
 	ConfigView* nextView;
+
+	static QAction *showNormalAction;
+	static QAction *showAllAction;
+	static QAction *showPromptAction;
 };
 
 class ConfigInfoView : public QTextBrowser {
-- 
1.6.3


